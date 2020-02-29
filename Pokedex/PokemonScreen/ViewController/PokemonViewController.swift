//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {
    
    var pokemonNumber = 0
    let dispatchGroup = DispatchGroup()
    var pokemon: Pokemon? {
        didSet {
            self.mainView.pokemon = self.pokemon
        }
    }
    var pokedexAPIClient = PokedexAPIClient()
    
    private var mainView: PokemonView {
        return self.view as! PokemonView
    }
    
    var cachePokemon: ((Pokemon?) -> Void)?
    
    convenience init(number: Int) {
        self.init(nibName: nil, bundle: nil)
        self.pokemonNumber = number
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.style()
    }
    
    override func loadView() {
        self.view = PokemonView()
    }
    
    func setup() {
        self.fetchPokemonViewData()
    }
    
    func style() {
        self.title = "Pokedex"
    }
    
}

extension PokemonViewController {
    
    private func fetchPokemonViewData() {
        var pkmn: Pokemon?
        var pkmnImg: UIImage?
        
        let loadingView = LoadingIndicatorView(frame: UIScreen.main.bounds, image: UIImage(named: "poke")!)
        self.view.addSubview(loadingView)
        loadingView.startAnimating()
        
        self.setPokemonImage() { image in
            pkmnImg = image
        }
        
        guard self.pokemon == nil else {
            self.dispatchGroup.notify(queue: .main){
                guard let img = pkmnImg else {
                    self.showAlert(withTitle: "Ops!", andMessage: "Something went wrong, try again.")
                    return
                }
                self.mainView.pokemonView.image = img
                loadingView.stopAnimating {
                    loadingView.removeFromSuperview()
                }
            }
            return
        }
        
        self.fetchPokemon(number: pokemonNumber) { element in
            pkmn = element
        }
        
        self.dispatchGroup.notify(queue: .main) { [unowned self] in
            loadingView.stopAnimating {
                loadingView.removeFromSuperview()
            }
            guard
                let img = pkmnImg,
                let poke = pkmn
                else {
                    self.showAlert(withTitle: "Ops!", andMessage: "Something went wrong, try again.")
                    return
            }
            self.pokemon = poke
            self.mainView.pokemonView.image = img
            
        }
    }
    
    
    private func setPokemonImage(completion: @escaping (UIImage?) -> Void) {
        self.dispatchGroup.enter()
        let request = PokeAPI.pokemonImage(number: self.pokemonNumber).url
        KingfisherManager.shared.retrieveImage(with: request, options: nil, progressBlock: nil) { [unowned self] result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure( _):
                completion(nil)
            }
            self.dispatchGroup.leave()
        }
        
    }
    
    private func fetchPokemon(number: Int, completion: @escaping (Pokemon?) -> Void) {
        self.dispatchGroup.enter()
        self.pokedexAPIClient.getPokemon(number: number, completion: { [unowned self] result in
            switch result {
            case .success(let pokemon):
                self.cachePokemon?(pokemon)
                completion(pokemon)
            case .failure( _):
                completion(nil)
            }
            self.dispatchGroup.leave()
        })
    }
}
