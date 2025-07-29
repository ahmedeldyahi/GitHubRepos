//
//  MockRepository.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//
@testable import GitHubRepos

final class MockRepository: GitHubRepositoryContract {
    var shouldThrow = false
    var mockRepositories: [Repository] = []
    
    func fetchRepositories() async throws -> [Repository] {
        if shouldThrow {
            throw NetworkError.invalidResponse
        }
        return mockRepositories
    }
}
