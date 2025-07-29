//
//  FetchRepositoriesUseCase.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

protocol FetchRepositoriesUseCaseContract {
    func execute() async throws -> [Repository]
}

final class FetchRepositoriesUseCase: FetchRepositoriesUseCaseContract {
    private let repository: GitHubRepositoryContract
    
    init(repository: GitHubRepositoryContract) {
        self.repository = repository
    }
    
    func execute() async throws -> [Repository] {
        try await repository.fetchRepositories()
    }
}
