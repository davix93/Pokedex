//
//  ViewController.swift
//  Pokedex
//
//  Created by Davide Tarantino on 26/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    var pokedexAPIClient = PokedexAPIClient()
    
    private var mainView: PokedexView {
        return self.view as! PokedexView
    }
    var pokemons: [Int: Pokemon] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.style()
    }

    override func loadView() {
        self.view = PokedexView()

        self.mainView.openPokemonDetail = { [unowned self] number in
            let viewController = PokemonViewController(number: number)
            if self.pokemons[number-1] == nil {
                viewController.cachePokemon = { [unowned self] pkmn in self.cachePokemon(pkmn: pkmn!)}
            } else {
                viewController.pokemon = self.pokemons[number-1]
            }
            self.present(viewController, animated: true)
        }
    }

    func setup() {
        self.fetchPokedex()

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search a Pokemon"
        search.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = search
    }

    func style() {
        self.title = "Pokedex"
    }

}

extension PokedexViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let text = searchController.searchBar.text,
            let dex = self.mainView.pokedex
        else { return }

        let results = text.isEmpty ? dex.results : dex.results.filter({
            $0.name.range(of: text, options: .caseInsensitive) != nil
        })

        self.mainView.filteredPokedex = Pokedex(results: results)
    }
}

extension PokedexViewController {

    func cachePokemon(pkmn: Pokemon) {
        self.pokemons[pkmn.number - 1] = pkmn
    }

    private func fetchPokedex() {

        self.pokedexAPIClient.getPokedex(count: 807, completion: { [unowned self] result in
            switch result {
            case .success(let pokedex):
                self.mainView.pokedex = pokedex
            case .failure(let error):
                self.showAlert(withTitle: "Ops!", andMessage: error.localizedDescription)
            }

        })

    }
}
