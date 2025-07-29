//
//  NetworkService.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol NetworkServiceContract {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkService: NetworkServiceContract {
    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await urlSession.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
