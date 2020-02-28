//
//  Extension.swift
//  Pokedex
//
//  Created by Davide Tarantino on 27/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
