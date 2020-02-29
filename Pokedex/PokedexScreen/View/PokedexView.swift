//
//  PokedexView.swift
//  Pokedex
//
//  Created by Davide Tarantino on 26/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit
import PinLayout

class PokedexView: UIView, PokeView {

    private let tableView = UITableView()
    var pokedex: Pokedex? {
        didSet {
            self.filteredPokedex = self.pokedex
            self.update()

        }
    }

    var filteredPokedex: Pokedex? {
        didSet {
            self.update()
        }
    }

    var openPokemonDetail: ((Int) -> Void)?

    init() {
        super.init(frame: .zero)

        self.setup()
        self.style()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PokedexCell.self, forCellReuseIdentifier: PokedexCell.reuseIdentifier)
        self.addSubview(self.tableView)
    }

    func style() {
        self.tableView.backgroundColor = pokedexColor
        self.tableView.separatorStyle = .none

    }

    func update() {
        self.tableView.reloadData()
    }

    func layout() {
        self.tableView.pin.all()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }
}

extension PokedexView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dex = filteredPokedex else {return 0}
        return dex.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let dex = self.filteredPokedex,
            let origDex = self.pokedex,
            let index = origDex.results.firstIndex(where: { $0.name == dex.results[indexPath.row].name })
        else {return UITableViewCell()}

        let cell = tableView.dequeueReusableCell(withIdentifier: PokedexCell.reuseIdentifier, for: indexPath) as? PokedexCell
        
        guard let pokedexCell = cell else {return UITableViewCell()}
        
        let name = dex.results[indexPath.row].name.capitalizingFirstLetter()

        pokedexCell.cellModel = PokedexCellModel(name: name, number: String(index+1))

        let request = PokeAPI.sprite(number: index + 1).url

        pokedexCell.sprite.kf.setImage(with: request)

        return pokedexCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let dex = self.filteredPokedex,
            let origDex = self.pokedex,
            let index = origDex.results.firstIndex(where: { $0.name == dex.results[indexPath.row].name })
        else {return}

        DispatchQueue.main.async {
            self.openPokemonDetail?(index + 1)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
