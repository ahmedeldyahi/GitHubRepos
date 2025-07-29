//
//  RepositoryListViewModelTests.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//


import XCTest
@testable import GitHubRepos

@MainActor
final class RepositoryListViewModelTests: XCTestCase {

    final class MockFetchRepositoriesUseCase: FetchRepositoriesUseCaseContract {
        var shouldThrow = false
        var mockRepositories: [Repository] = []

        func execute() async throws -> [Repository] {
            if shouldThrow {
                throw NetworkError.invalidResponse
            }
            return mockRepositories
        }
    }

    func testFetchRepositories_Success() async {
        // Given
        let mockUseCase = MockFetchRepositoriesUseCase()
        mockUseCase.mockRepositories = [
            Repository(id: 1, name: "Repo1", owner: Owner(id: 1, username: "ahmed", avatarURL: URL(string: "https://img.com")!), createdAt: Date(), htmlURL: URL(string: "https://repo1.com")!)
        ]
        let viewModel = RepositoryListViewModel(fetchUseCase: mockUseCase)

        // When
        await viewModel.fetchRepositories()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.repositories.count, 1)
        XCTAssertEqual(viewModel.repositories.first?.name, "Repo1")
    }

    func testFetchRepositories_Failure() async {
        // Given
        let mockUseCase = MockFetchRepositoriesUseCase()
        mockUseCase.shouldThrow = true
        let viewModel = RepositoryListViewModel(fetchUseCase: mockUseCase)

        // When
        await viewModel.fetchRepositories()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.repositories.isEmpty)
    }

    func testIsLoadingState_ChangesDuringFetch() async {
        // Given
        let mockUseCase = MockFetchRepositoriesUseCase()
        let viewModel = RepositoryListViewModel(fetchUseCase: mockUseCase)

        let expectation = XCTestExpectation(description: "isLoading toggled correctly")

        // Track isLoading changes
        var isLoadingStates: [Bool] = []

        let cancellable = viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                isLoadingStates.append(isLoading)
                if isLoadingStates.count == 2 {
                    expectation.fulfill()
                }
            }

        // When
        await viewModel.fetchRepositories()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(isLoadingStates, [true, false])

        cancellable.cancel()
    }
}