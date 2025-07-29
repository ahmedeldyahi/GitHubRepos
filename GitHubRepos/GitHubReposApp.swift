//
//  GitHubReposApp.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import SwiftUI

@main
struct GitHubReposApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoryListView(
                viewModel: RepositoryListViewModel(
                    fetchUseCase: FetchRepositoriesUseCase(
                        repository: GitHubRepository()
                    )
                )
            )
        }
    }
}
