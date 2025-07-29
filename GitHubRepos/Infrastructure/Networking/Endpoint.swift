//
//  Endpoint.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import Foundation

enum Endpoint {
    case repositories
    
    var urlRequest: URLRequest {
        let url: URL
        switch self {
        case .repositories:
            url = URL(string: "https://api.github.com/repositories")!
        }
        return URLRequest(url: url)
    }
}

enum NetworkError: Error {
    case invalidResponse
    case invalidURL
}
