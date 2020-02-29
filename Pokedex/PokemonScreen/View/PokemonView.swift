//
//  PokemonView.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation
import UIKit
import PinLayout

class PokemonView: UIView, PokeView {

    let backgroundView = UIView()
    let pokemonView = UIImageView()
    let numberLabel = UILabel()
    let nameLabel = UILabel()
    let typesCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let flowLayout = UICollectionViewFlowLayout()
    let statsTableView = UITableView()

    var pokemon: Pokemon? {
        didSet {
            self.update()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.style()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.statsTableView.dataSource = self
        self.statsTableView.delegate = self
        self.statsTableView.isScrollEnabled = false
        self.statsTableView.register(StatCell.self, forCellReuseIdentifier: StatCell.reuseIdentifier)

        self.flowLayout.scrollDirection = .horizontal
        self.typesCollection.setCollectionViewLayout(self.flowLayout, animated: false)
        self.typesCollection.delegate = self
        self.typesCollection.dataSource = self
        self.typesCollection.register(TypeCell.self, forCellWithReuseIdentifier: TypeCell.reuseIdentifier)

        self.addSubview(self.backgroundView)
        self.addSubview(self.pokemonView)
        self.addSubview(self.numberLabel)
        self.addSubview(self.nameLabel)
        self.addSubview(self.typesCollection)
        self.addSubview(self.statsTableView)
    }

    func style() {
        self.backgroundColor = pokedexColor

        self.backgroundView.backgroundColor = .white

        self.pokemonView.backgroundColor = .clear

        self.numberLabel.textColor = .white
        self.numberLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)

        self.nameLabel.textColor = .black
        self.nameLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)

        self.typesCollection.backgroundColor = .white

        self.statsTableView.separatorStyle = .none
        self.statsTableView.backgroundColor = .clear

    }

    func layout() {
        self.numberLabel.pin
            .top(3%)
            .hCenter()
            .sizeToFit()

        self.pokemonView.pin
            .top(10%)
            .hCenter()
            .height(28%)
            .aspectRatio(1)

        self.nameLabel.pin
            .below(of: self.pokemonView)
            .marginTop(1%)
            .hCenter()
            .sizeToFit()

        self.typesCollection.pin
            .below(of: self.nameLabel)
            .marginTop(2%)
            .width(100%)
            .height(7%)

        self.backgroundView.pin
            .bottom()
            .left()
            .right()
            .top(25%)

        self.statsTableView.pin
            .below(of: self.typesCollection)
            .marginTop(2%)
            .hCenter()
            .width(80%)
            .bottom(pin.safeArea)

        self.backgroundView.roundCorners([.topLeft, .topRight], radius: 16)
    }

    func update() {
        guard let pkmn = self.pokemon else {return}

        self.numberLabel.text = "N° \(pkmn.number)"
        self.nameLabel.text = pkmn.name.capitalizingFirstLetter()
        self.typesCollection.reloadData()
        self.statsTableView.reloadData()

        guard
            let mainType = pkmn.types.last,
            let type = PokeType(rawValue: mainType.type.name)
        else {return}

        self.backgroundColor = type.getColor()

        self.layoutIfNeeded()
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }
}

extension PokemonView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pkmn = self.pokemon else {return 0}

        return pkmn.stats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pkmn = self.pokemon else {return UITableViewCell()}

        let cell = tableView.dequeueReusableCell(withIdentifier: StatCell.reuseIdentifier, for: indexPath) as? StatCell

        guard let pokemonCell = cell else {return UITableViewCell()}
        
        let cellModel = StatCellModel(pokemonStat: pkmn.stats[indexPath.row], color: self.backgroundColor ?? pokedexColor)

        pokemonCell.statCellModel = cellModel

        return pokemonCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PokemonView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.frame.size.height/10)*7
        let width: CGFloat = 90
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemWidth: CGFloat = 90
        let spacingWidth = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
        let numberOfItems: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        let cellSpacingWidth = numberOfItems * (spacingWidth ?? 0)
        let totalCellWidth = numberOfItems * itemWidth + cellSpacingWidth
        let inset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let pkmn = self.pokemon else {return 0}

        return pkmn.types.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCell.reuseIdentifier, for: indexPath) as? TypeCell

        guard
            let pokedexCell = cell,
            let pkmn = self.pokemon,
            let type = PokeType(rawValue: pkmn.types[(pkmn.types.count-1) - indexPath.row].type.name)
            else {return UICollectionViewCell()}

        pokedexCell.type = type

        return pokedexCell
    }
}
