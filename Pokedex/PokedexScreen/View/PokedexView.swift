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
            self.tableView.reloadData()
        }
    }
    
    var openPokemonDetail: ((Int) ->())?
    
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
        guard let dex = pokedex else {return 0}
        return dex.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dex = pokedex else {return UITableViewCell()}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PokedexCell.reuseIdentifier, for: indexPath) as! PokedexCell
        
        cell.cellModel = PokedexCellModel(name: dex.results[indexPath.row].name.capitalizingFirstLetter(), number: String(indexPath.row + 1))
        
        let request = PokeAPI.sprite(number: indexPath.row + 1).url
        cell.sprite.kf.setImage(with: request)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        DispatchQueue.main.async {
            self.openPokemonDetail?(indexPath.row + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


