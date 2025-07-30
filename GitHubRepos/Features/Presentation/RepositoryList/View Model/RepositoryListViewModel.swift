//
//  RepositoryListViewModel.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import Combine
final class RepositoryListViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    private let fetchUseCase: FetchRepositoriesUseCaseContract
    
    init(fetchUseCase: FetchRepositoriesUseCaseContract) {
        self.fetchUseCase = fetchUseCase
    }
    
    @MainActor
     func fetchRepositories() async {
         isLoading = true
         errorMessage = nil
         
         defer { isLoading = false }
         
         do {
             repositories = try await fetchUseCase.execute()
         } catch {
             errorMessage = error.localizedDescription
         }
     }
 }

