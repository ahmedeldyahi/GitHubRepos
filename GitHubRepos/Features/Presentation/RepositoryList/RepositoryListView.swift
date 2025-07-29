//
//  RepositoryListView.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel: RepositoryListViewModel
    @State private var showErrorAlert = false
    
    init(viewModel: RepositoryListViewModel = RepositoryListViewModel(
        fetchUseCase: FetchRepositoriesUseCase(
            repository: GitHubRepository(
                networkService: NetworkService()
            )
        )
    )) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // Content
                Group {
                    if viewModel.isLoading && viewModel.repositories.isEmpty {
                        loadingView
                    } else if viewModel.repositories.isEmpty {
                        emptyStateView
                    } else {
                        repositoryList
                    }
                }
            }
            .navigationTitle("GitHub Repositories")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {}
                Button("Retry") {
                    Task { await viewModel.fetchRepositories() }
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
            .task {
                await viewModel.fetchRepositories()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            Text("Loading repositories...")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 20)
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
                .padding()
            
            Text("No Repositories Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(viewModel.errorMessage ?? "Try refreshing or check your connection")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
            
            Button(action: {
                Task { await viewModel.fetchRepositories() }
            }) {
                Text("Refresh")
                    .font(.headline)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            Spacer()
        }
    }
    
    private var repositoryList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Repository cards
                ForEach(viewModel.repositories) { repository in
                    NavigationLink {
                        RepositoryDetailView(repository: repository)
                    } label: {
                        RepositoryCell(repository: repository)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 16)
        }
        .refreshable {
            await viewModel.fetchRepositories()
        }
    }
    
    private var refreshButton: some View {
        Button(action: {
            Task { await viewModel.fetchRepositories() }
        }) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        }
        .disabled(viewModel.isLoading)
    }
}

// MARK: - Preview
struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockOwner = Owner(
            id: 1,
            username: "apple",
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!
        )
        
        let recentDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        let oldDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        
        let mockRepositories = [
            Repository(
                id: 1,
                name: "swift",
                owner: mockOwner,
                createdAt: recentDate,
                htmlURL: URL(string: "https://github.com/apple/swift")!
            ),
            Repository(
                id: 2,
                name: "swift-package-manager",
                owner: mockOwner,
                createdAt: oldDate,
                htmlURL: URL(string: "https://github.com/apple/swift-package-manager")!
            )
        ]
        
        // Loading state
        let loadingViewModel = RepositoryListViewModel(
            fetchUseCase: FetchRepositoriesUseCase(
                repository: MockGitHubRepository()
            )
        )
        loadingViewModel.isLoading = true
        
        // Empty state
        let emptyViewModel = RepositoryListViewModel(
            fetchUseCase: FetchRepositoriesUseCase(
                repository: MockGitHubRepository()
            )
        )
        emptyViewModel.errorMessage = "No repositories available"
        
        // Loaded state
        let loadedViewModel = RepositoryListViewModel(
            fetchUseCase: FetchRepositoriesUseCase(
                repository: MockGitHubRepository()
            )
        )
        loadedViewModel.repositories = mockRepositories
        
        return Group {
            RepositoryListView(viewModel: loadingViewModel)
                .previewDisplayName("Loading State")
            
            RepositoryListView(viewModel: emptyViewModel)
                .previewDisplayName("Empty State")
            
            RepositoryListView(viewModel: loadedViewModel)
                .previewDisplayName("Loaded State")
                .preferredColorScheme(.dark)
        }
    }
}


// MARK: - Mock for Preview
class MockGitHubRepository: GitHubRepositoryContract {
    func fetchRepositories() async throws -> [Repository] {
        let owner = Owner(id: 1, username: "octocat", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/583231?v=4")!)
        let date = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        return [
            Repository(
                id: 1,
                name: "Hello-World",
                owner: owner,
                createdAt: date,
                htmlURL: URL(string: "https://github.com/octocat/Hello-World")!
            )
        ]
    }
}
