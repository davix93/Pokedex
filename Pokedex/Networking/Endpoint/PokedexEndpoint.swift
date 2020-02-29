//
//  PokedexEndpoint.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation

enum PokeAPI {
    case sprite(number: Int)
    case pokedex(limit: Int)
    case pokemon(number: Int)
    case pokemonImage(number: Int)
}

extension PokeAPI: Endpoint {
    var base: String {
        switch self {
        case .pokedex, .pokemon: return "https://pokeapi.co"
        case .sprite: return "https://raw.githubusercontent.com"
        case .pokemonImage: return "https://pokeres.bastionbot.org"
        }

    }

    var path: String {
        switch self {
        case .pokedex: return "/api/v2/pokemon"
        case .pokemon(let number): return "/api/v2/pokemon/\(number)"
        case .sprite(let number): return "/PokeAPI/sprites/master/sprites/pokemon/\(number).png"
        case .pokemonImage(let number): return "/images/pokemon/\(number).png"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .pokedex(let limit): return [ URLQueryItem(name: "limit", value: String(limit)) ]
        default: return []
        }
    }
}
