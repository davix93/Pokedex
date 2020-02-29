//
//  Model.swift
//  Pokedex
//
//  Created by Davide Tarantino on 26/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

struct Pokedex: Decodable {
    var results: [NamedAPIResource]
}

struct Pokemon: Decodable {
    let number: Int
    let name: String
    var types: [PokemonType]
    let stats: [PokemonStat]

    private enum CodingKeys: String, CodingKey {
            case name,types,stats
            case number = "id"
    }
}

struct PokemonType: Decodable {
    let type: NamedAPIResource
}

struct PokemonStat: Decodable {
    let stat: NamedAPIResource
    let baseStatValue: Int

    private enum CodingKeys: String, CodingKey {
        case stat
        case baseStatValue = "base_stat"
    }
}

struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}

