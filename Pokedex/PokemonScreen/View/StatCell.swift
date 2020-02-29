//
//  StatCell.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit
import PinLayout

class StatCell: UITableViewCell {

    let statLabel = UILabel()
    let statNumberLabel = UILabel()
    let statBar = LevelBar()

    static let reuseIdentifier = "StatCell"

    var statCellModel: StatCellModel? {
        didSet {
            self.update()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setup()
        self.style()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.contentView.addSubview(self.statLabel)
        self.contentView.addSubview(self.statNumberLabel)
        self.contentView.addSubview(self.statBar)

    }

    func style() {
        self.selectionStyle = .none

        self.statNumberLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.statNumberLabel.textColor = .black
        self.statNumberLabel.textAlignment = .right

        self.statLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.statLabel.textColor = .black

        self.backgroundColor = .clear
    }

    func update() {
        guard let model = self.statCellModel else {return}

        self.statLabel.text = Stats.getStat(for: model.pokemonStat.stat.name)
        self.statNumberLabel.text = String(model.pokemonStat.baseStatValue)
        self.statBar.setLevel(model.pokemonStat.baseStatValue)
        self.statBar.setColor(model.color)

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func layout() {
        self.statLabel.pin
            .left()
            .marginLeft(2%)
            .width(5%)
            .sizeToFit(.heightFlexible)

        self.statNumberLabel.pin
            .left(18%)
            .width(9%)
            .height(of: self.statLabel)


        self.statBar.pin
            .after(of: statNumberLabel, aligned: .center)
            .marginLeft(5%)
            .right()
            .height(25%)

        self.contentView.pin
            .wrapContent(.vertically, padding: 11.5)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.contentView.pin.width(size.width)
        self.layout()
        return CGSize(width: self.contentView.frame.width, height: self.contentView.frame.maxY)
    }

}

struct StatCellModel {
    let pokemonStat: PokemonStat
    let color: UIColor
}

enum Stats: String {
    case speed
    case attack
    case specialAttack = "special-attack"
    case defense
    case specialDefense = "special-defense"
    case hp

    static func getStat(for string: String) -> String {
        switch string {
        case Stats.speed.rawValue:
            return "SPD"
        case Stats.attack.rawValue:
            return "ATK"
        case Stats.specialAttack.rawValue:
            return "SATK"
        case Stats.defense.rawValue:
            return "DEF"
        case Stats.specialDefense.rawValue:
            return "SDEF"
        case Stats.hp.rawValue:
            return "HP"
        default:
            return ""
        }
    }
}
