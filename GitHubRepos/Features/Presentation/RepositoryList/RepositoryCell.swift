//
//  RepositoryCell.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import SwiftUI
struct RepositoryCell: View {
    let repository: Repository
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Avatar with status indicator
            avatarSection
            
            // Text content
            VStack(alignment: .leading, spacing: 6) {
                Text(repository.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                ownerSection
                
                HStack(spacing: 8) {
                    dateBadge
                    Spacer()
                    disclosureIndicator
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
    
    // MARK: - Subviews
    
    private var avatarSection: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: repository.owner.avatarURL) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
            }
            .clipShape(Circle())
            .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1))
            
            // Online status indicator
            Circle()
                .fill(Color.green)
                .frame(width: 12, height: 12)
                .overlay(Circle().stroke(Color(.secondarySystemBackground), lineWidth: 2))
                .offset(x: 2, y: 2)
        }
    }
    
    private var ownerSection: some View {
        HStack(spacing: 6) {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(.secondary)
            
            Text(repository.owner.username)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    private var dateBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(.secondary)
            
            Text(formattedDate(from: repository.createdAt))
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color(.tertiarySystemBackground))
        )
    }
    
    private var disclosureIndicator: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(Color(.tertiaryLabel))
            .padding(6)
    }
    
    // MARK: - Helper
    
    private func formattedDate(from date: Date) -> String {
        return DateFormatter.relativeOrFormattedDate(from: date)
    }
}

// MARK: - Preview
struct RepositoryCell_Previews: PreviewProvider {
    static var previews: some View {
        let mockOwner = Owner(
            id: 1,
            username: "apple",
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!
        )
        
        let recentDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        let oldDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        
        let recentRepo = Repository(
            id: 1,
            name: "swift-language",
            owner: mockOwner,
            createdAt: recentDate,
            htmlURL: URL(string: "https://github.com/apple/swift")!
        )
        
        let oldRepo = Repository(
            id: 2,
            name: "swift-package-manager",
            owner: mockOwner,
            createdAt: oldDate,
            htmlURL: URL(string: "https://github.com/apple/swift-package-manager")!
        )
        
        return Group {
            RepositoryCell(repository: recentRepo)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Recent Repo")
            
            RepositoryCell(repository: oldRepo)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Old Repo")
                .preferredColorScheme(.dark)
        }
    }
}
