//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    var pokemonNumber = 0
    var pokemon: Pokemon? {
        didSet{
            self.mainView.pokemon = self.pokemon
        }
    }
    var pokedexAPIClient = PokedexAPIClient()
    
    private var mainView: PokemonView {
        return self.view as! PokemonView
    }
    
    var cachePokemon: ((Pokemon?) -> ())?
    
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
        self.setPokemonImage()
        guard pokemon == nil else {return}
        self.fetchPokemon(number: pokemonNumber)
    }
    
    
    func style() {
        self.title = "Pokedex"
    }
    
}

extension PokemonViewController {
    
    private func setPokemonImage(){
        let request = PokeAPI.pokemonImage(number: self.pokemonNumber).url
        self.mainView.pokemonView.kf.setImage(with: request, options: [.transition(.fade(0.2))])
    }
    
    private func fetchPokemon(number: Int){
            self.pokedexAPIClient.getPokemon(number: number, completion: { result in
                switch result {
                case .success(let pokemon):
                    self.pokemon = pokemon
                    self.cachePokemon?(pokemon)
                case .failure(let error):
                    print(error)
                }
            })
        }
}
