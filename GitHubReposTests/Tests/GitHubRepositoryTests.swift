//
//  FetchRepositoriesUseCaseTests.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//

import XCTest
@testable import GitHubRepos

final class GitHubRepositoryTests: XCTestCase {

    func testFetchRepositories_ReturnsMappedRepositories() async throws {
        let mockService = MockNetworkService()
        mockService.mockDTOs = [makeMockDTO(id: 1), makeMockDTO(id: 2)]

        let repository = GitHubRepository(networkService: mockService)
        let useCase = FetchRepositoriesUseCase(repository: repository)

        let result = try await useCase.execute()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, "TestRepo")
    }

    func testFetchRepositories_ThrowsError() async {
        let mockService = MockNetworkService()
        mockService.shouldThrowError = true

        let repository = GitHubRepository(networkService: mockService)
        let useCase = FetchRepositoriesUseCase(repository: repository)

        do {
            let _ = try await useCase.execute()
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
}
