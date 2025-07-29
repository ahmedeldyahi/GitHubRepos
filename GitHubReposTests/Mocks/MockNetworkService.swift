//
//  MockNetworkService.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//
@testable import GitHubRepos

 final class MockNetworkService: NetworkServiceContract {
        var mockDTOs: [GitHubRepositoryDTO] = []
        var shouldThrowError = false

        func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
            if shouldThrowError {
                throw NetworkError.invalidResponse
            }
            return mockDTOs as! T
        }
    }

    func makeMockDTO(id: Int = 1) -> GitHubRepositoryDTO {
        return GitHubRepositoryDTO(
            id: id,
            name: "TestRepo",
            owner: OwnerDTO(id: 100, login: "Ahmed", avatarURL: "https://avatar.com"),
            createdAt: "2023-10-10T12:00:00Z",
            htmlURL: "https://github.com/test"
        )
    }
