//
//  TypeView.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation
import UIKit
import PinLayout

class TypeCell: UICollectionViewCell, PokeView {

    static let reuseIdentifier = "TypeCell"

    var name = UILabel()

    var type: PokeType? {
        didSet {
            self.update()
        }
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.setup()
        self.style()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.contentView.addSubview(self.name)
    }

    func style() {

        self.name.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.name.textColor = .white
        self.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true

    }

    func update() {
        guard let type = self.type else {return}
        self.backgroundColor = type.getColor()
        self.name.text = type.rawValue.capitalizingFirstLetter()
    }

    func layout() {
        self.name.pin
            .center()
            .sizeToFit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }

}

enum PokeType: String {
    case normal
    case fire
    case water
    case grass
    case electric
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dark
    case dragon
    case steel
    case fairy

    func getColor() -> UIColor {
        switch self.rawValue {
        case PokeType.normal.rawValue:
            return normalColor
        case PokeType.fire.rawValue:
            return fireColor
        case PokeType.water.rawValue:
            return waterColor
        case PokeType.grass.rawValue:
            return grassColor
        case PokeType.electric.rawValue:
            return electricColor
        case PokeType.ice.rawValue:
            return iceColor
        case PokeType.fighting.rawValue:
            return fightingColor
        case PokeType.poison.rawValue:
            return poisonColor
        case PokeType.ground.rawValue:
            return groundColor
        case PokeType.flying.rawValue:
            return flyingColor
        case PokeType.psychic.rawValue:
            return psychicColor
        case PokeType.bug.rawValue:
            return bugColor
        case PokeType.rock.rawValue:
            return rockColor
        case PokeType.ghost.rawValue:
            return ghostColor
        case PokeType.dark.rawValue:
            return darkColor
        case PokeType.dragon.rawValue:
            return dragonColor
        case PokeType.steel.rawValue:
            return steelColor
        case PokeType.fairy.rawValue:
            return fairyColor
        default:
            return .black
        }
    }
}
