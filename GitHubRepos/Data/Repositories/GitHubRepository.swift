//
//  GitHubRepository.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//
protocol GitHubRepositoryContract {
    func fetchRepositories() async throws -> [Repository]
}

final class GitHubRepository: GitHubRepositoryContract {
    private let networkService: NetworkServiceContract
    
    init(networkService: NetworkServiceContract = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchRepositories() async throws -> [Repository] {
        let endpoint = Endpoint.repositories
        let dto: [GitHubRepositoryDTO] = try await networkService.request(endpoint)
        
        return dto.map {  $0.toDomain() }
    }
}
