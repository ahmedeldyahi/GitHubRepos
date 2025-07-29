//
//  MockURLSession.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//
import Foundation
@testable import GitHubRepos

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), mockResponse ?? HTTPURLResponse())
    }
}
