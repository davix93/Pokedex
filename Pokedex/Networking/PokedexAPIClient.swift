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
                
        let request = PokeAPI.pokedex(limit: count).request
        
        self.fetchData(from: request, decode: { json -> Pokedex? in
            
            guard let results = json as? Pokedex else { return nil }
            
            return results
            
        }, completion: completion)
    }
    
    typealias PokemonCompletionHandler = (Result<Pokemon?, NetworkError>) -> Void

    func getPokemon(number: Int, completion: @escaping PokemonCompletionHandler){
                
        let request = PokeAPI.pokemon(number: number).request
        
        print(request.url)
        
        self.fetchData(from: request, decode: { json -> Pokemon? in
            
            guard let results = json as? Pokemon else { return nil }
            
            return results
            
        }, completion: completion)
    }
    
    
}
