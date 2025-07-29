//
//  FetchRepositoriesUseCaseTests.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//


import XCTest
@testable import GitHubRepos

final class FetchRepositoriesUseCaseTests: XCTestCase {

    func testExecute_ReturnsRepositories() async throws {
        let mockRepo = MockRepository()
        mockRepo.mockRepositories = [
            Repository(id: 1, name: "Repo1", owner: Owner(id: 1, username: "ahmed", avatarURL: URL(string: "https://image.com")!), createdAt: Date(), htmlURL: URL(string: "https://repo1.com")!),
            Repository(id: 2, name: "Repo2", owner: Owner(id: 2, username: "ali", avatarURL: URL(string: "https://image.com")!), createdAt: Date(), htmlURL: URL(string: "https://repo2.com")!)
        ]
        let useCase = FetchRepositoriesUseCase(repository: mockRepo)

        let result = try await useCase.execute()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, "Repo1")
    }

    func testExecute_ThrowsError() async {
        let mockRepo = MockRepository()
        mockRepo.shouldThrow = true
        let useCase = FetchRepositoriesUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
}
