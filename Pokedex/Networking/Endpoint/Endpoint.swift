//
//  Endpoint.swift
//  Pokedex
//
//  Created by Davide Tarantino on 28/02/2020.
//  Copyright © 2020 Davide Tarantino. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
    
    var url: URL {
        return urlComponents.url!
    }
}
