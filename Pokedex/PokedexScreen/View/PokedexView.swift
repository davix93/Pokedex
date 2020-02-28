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
    var pokemons: [Pokemon?] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var pokedex: Pokedex? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var pokeSprites: [PokemonSprite] = []
    
    var fetchNextPokemons: ((Int,Int)->())?
    
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
        self.addSubview(tableView)
    }
    
    func style() {
        self.tableView.backgroundColor = UIColor(red: 0.92, green: 0.39, blue: 0.33, alpha: 1)

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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.pokemons.count
        
        if indexPath.row == count - 2 {
            self.fetchNextPokemons?(count + 1 ,10)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dex = pokedex else {return 0}
        return dex.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dex = pokedex else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PokedexCell.reuseIdentifier, for: indexPath) as! PokedexCell
        
        cell.configure(name: dex.results[indexPath.row].name, number: String(indexPath.row + 1))
        
        if let p = pokemons[safe: indexPath.row], let pkmn = p{
            cell.sprite.kf.setImage(with: URL(string: pkmn.image.sprite))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


