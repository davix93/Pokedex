//
//  PokeView.swift
//  Pokedex
//
//  Created by Davide Tarantino on 27/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation
import UIKit

protocol PokeView: UIView {
    func setup()
    func style()
    func layout()
}
