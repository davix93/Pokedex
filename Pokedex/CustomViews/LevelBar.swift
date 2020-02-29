//
//  LevelBar.swift
//  Pokedex
//
//  Created by Davide Tarantino on 29/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import UIKit
import PinLayout

class LevelBar: UIView, PokeView {

    let progressBar = UIView()
    let color: UIColor
    var percentage = 0
    let maxBaseStat = 255

    init(color: UIColor = pokedexColor) {
        self.color = color

        super.init(frame: .zero)

        self.setup()
        self.style()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.addSubview(self.progressBar)
    }

    func style() {
        self.backgroundColor = levelBarBackgroundColor
        self.progressBar.backgroundColor = color

    }

    func layout() {

        self.progressBar.pin
            .left()
            .top()
            .bottom()
            .right(self.percentage%)

        self.layer.cornerRadius = 5
        self.progressBar.layer.cornerRadius = 5

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layout()
    }

    func setColor(_ color: UIColor) {
        self.progressBar.backgroundColor = color
    }

    func setLevel(_ number: Int) {

        self.percentage = 100 - (number * 100 / self.maxBaseStat)

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
