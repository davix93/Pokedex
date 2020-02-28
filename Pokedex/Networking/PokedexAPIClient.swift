//
//  PokedexAPIClient.swift
//  Pokedex
//
//  Created by Davide Tarantino on 27/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//
import Foundation

class PokedexAPIClient: APIClient {
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias PokedexCompletionHandler = (Result<Pokedex?, NetworkError>) -> Void
    
    func getPokedex(count: Int, completion: @escaping PokedexCompletionHandler){
        
        let urlString = "https://pokeapi.co/api/v2/pokemon/?limit=\(count)"

        self.fetchData(from: urlString,
              decode: { json -> Pokedex? in
                
                guard let results = json as? Pokedex else { return nil }
                return results
        }, completion: completion)
    }
    
    typealias PokemonCompletionHandler = (Result<Pokemon?, NetworkError>) -> Void

    func getPokemon(number: Int, completion: @escaping PokemonCompletionHandler){
        
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(number)"

        self.fetchData(from: urlString,
              decode: { json -> Pokemon? in
                
                guard let results = json as? Pokemon else { return nil }
                return results
        }, completion: completion)
    }
    
    typealias PokemonSpriteCompletionHandler = (Result<PokemonSprite?, NetworkError>) -> Void
    
    func getPokemonSprite(number: Int, completion: @escaping PokemonSpriteCompletionHandler){
        
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png"

        self.fetchData(from: urlString,
              decode: { json -> PokemonSprite? in
                
                guard let results = json as? PokemonSprite else { return nil }
                return results
        }, completion: completion)
    }
    //    typealias DetailCompletionHandler = (Result<Detail?, APIError>) -> Void
//
//    func getMoreInfoForProduct(withId id: String, completion: @escaping DetailCompletionHandler) {
//        let request = YooxAPI.detail(id: id).request
//
//        fetch(with: request, decode: { json -> Detail? in
//            guard let detail = json as? Detail else { return nil }
//            return detail
//        }, completion: completion)
//    }
}
