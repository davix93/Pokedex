//
//  APIClient.swift
//  Pokedex
//
//  Created by Davide Tarantino on 27/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation

protocol APIClient {
    
    var session: URLSession { get }
    func fetchData<T: Decodable>(from url: URLRequest,
                                 decode: @escaping (Decodable) -> T?,
                                 completion: @escaping (Result<T, NetworkError>) -> Void)
}

extension APIClient {
    
    func fetchData<T: Decodable>(from url: URLRequest,
                                 decode: @escaping (Decodable) -> T?,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        session.dataTask(with: url) { data, _, error in
            if let _ = error as? URLError {
                completion(.failure(.requestFailed))
            }
            
            else if let data = data {
                do {
                    let genericModel = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        if let value = decode(genericModel) {
                            completion(.success(value))
                        } else {
                            completion(.failure(.jsonParsingError))
                        }
                    }
                } catch {
                    completion(.failure(.requestFailed))
                }
            }
            else {
                completion(.failure(.requestFailed))
            }
        }.resume()
        
    }
}
