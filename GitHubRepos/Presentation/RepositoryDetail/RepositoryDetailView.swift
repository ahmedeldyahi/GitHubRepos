//
//  RepositoryDetailView.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import SwiftUI
struct RepositoryDetailView: View {
    let repository: Repository
    @State private var showShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                
                creationDateSection
                
                detailsSection
                
                actionButtons
            }
            .padding()
        }
        .navigationTitle("Repository Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [repository.htmlURL])
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: repository.owner.avatarURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.primary.opacity(0.1), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(repository.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                    Text(repository.owner.username)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var creationDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Created", systemImage: "calendar")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                    .frame(width: 24)
                
                Text(DateFormatter.relativeOrFormattedDate(from: repository.createdAt))
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(formattedDaysSinceCreation)
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            .padding(12)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(10)
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Repository Information", systemImage: "info.circle")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 0) {
                DetailRow(
                    icon: "number",
                    title: "ID",
                    value: "\(repository.id)",
                    isLast: false
                )
                
                DetailRow(
                    icon: "link",
                    title: "GitHub URL",
                    value: repository.htmlURL.absoluteString,
                    isLast: true
                )
            }
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                UIApplication.shared.open(repository.htmlURL)
            }) {
                HStack {
                    Image("github-mark") // Add GitHub logo asset
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                    Text("View on GitHub")
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 12)
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(10)
            }
            
            Button(action: {
                showShareSheet = true
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Repository")
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 12)
                .foregroundColor(.primary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Helper Computed Properties
    
    private var formattedDaysSinceCreation: String {
        let days = Calendar.current.dateComponents([.day], from: repository.createdAt, to: Date()).day ?? 0
        return "\(days) days ago"
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockOwner = Owner(
            id: 1,
            username: "octocat",
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/583231?v=4")!
        )
        
        let mockDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        let mockRepository = Repository(
            id: 1,
            name: "Hello-World",
            owner: mockOwner,
            createdAt: mockDate,
            htmlURL: URL(string: "https://github.com/octocat/Hello-World")!
        )
        
        return NavigationView {
            RepositoryDetailView(repository: mockRepository)
        }
    }
}
