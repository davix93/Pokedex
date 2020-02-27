//
//  APIError.swift
//  Pokedex
//
//  Created by Davide Tarantino on 27/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL, requestFailed, unknown, jsonParsingError
}
