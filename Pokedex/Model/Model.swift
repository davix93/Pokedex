//
//  Model.swift
//  Pokedex
//
//  Created by Davide Tarantino on 26/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

struct Pokedex: Decodable {
    let results: [NamedAPIResource]
}

struct Pokemon: Decodable {
    let number: Int
    let name: String
    let image: PokemonSprite
    let types: [PokemonType]
    let stats: [PokemonStat]

    private enum CodingKeys: String, CodingKey {
            case name,types,stats
            case image = "sprites", number = "id"
    }
}

struct PokemonSprite: Decodable {
    let sprite: String
    
    private enum CodingKeys: String, CodingKey {
        case sprite = "front_default"
    }
}

struct PokemonType: Decodable {
    let slot: Int
    let type: NamedAPIResource
}

struct PokemonStat: Decodable {
    let stat: NamedAPIResource
    let effort: Int
    let baseStatValue: Int

    private enum CodingKeys: String, CodingKey {
        case stat, effort
        case baseStatValue = "base_stat"
    }
}

struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}

