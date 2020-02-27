//
//  ViewController.swift
//  Pokedex
//
//  Created by Davide Tarantino on 26/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {
    
//    var pokemons: [NamedAPIResource]?
    var pokedexAPIClient = PokedexAPIClient()
    
    private var mainView: PokedexView {
        return self.view as! PokedexView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.92, green: 0.38, blue: 0.32, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        self.title = "Pokedex"
        
        self.fetchPokedex()
        self.fetchPokemons(from: 1, times: 20)
        
    }

    
    override func loadView() {
        self.view = PokedexView()
        self.mainView.fetchNextPokemons = { [unowned self] start, count in
            self.fetchPokemons(from: start, times: count)
        }
    }
    
    private func fetchPokedex() {
        
        self.pokedexAPIClient.getPokedex(count: 964, completion: { result in
            switch result {
            case .success(let pokedex):
                self.mainView.pokedex = pokedex
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    private func fetchPokemons(from start: Int, times count: Int) {
        
        var tmpPokemons: [Pokemon] = []
        let dspGroup = DispatchGroup()
        let end = start + count
        
        for index in start...end{
            dspGroup.enter()
            self.pokedexAPIClient.getPokemon(number: index, completion: { result in
                switch result {
                case .success(let pokemon):
                    tmpPokemons.append(pokemon!)
                case .failure(let error):
                    print(error)
                }
                dspGroup.leave()
            })
        }
        dspGroup.notify(queue: .main) {
            self.mainView.pokemons.append(contentsOf: tmpPokemons)
            
        }
    }

}
