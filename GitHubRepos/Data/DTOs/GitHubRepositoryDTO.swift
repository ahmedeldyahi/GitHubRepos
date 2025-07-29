//
//  GitHubRepositoryDTO.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import Foundation

struct GitHubRepositoryDTO: Decodable {
    let id: Int
    let name: String
    let owner: OwnerDTO
    let createdAt: String?
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, owner
        case createdAt = "created_at"
        case htmlURL = "html_url"
    }
}

struct OwnerDTO: Decodable {
    let id: Int
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURL = "avatar_url"
    }
}

extension GitHubRepositoryDTO {
    func toDomain() -> Repository {
        let createdAtDate: Date
        if let dateString = createdAt,
           let parsedDate = DateFormatter.repositoryDateFormatter.date(from: dateString) {
            createdAtDate = parsedDate
        } else {
            createdAtDate = Date()
        }

        let owner = owner.toDomain()
        let htmlURL = URL(string: htmlURL) ?? URL(string: "https://github.com")!

        return Repository(
            id: id,
            name: name,
            owner: owner,
            createdAt: createdAtDate,
            htmlURL: htmlURL
        )
    }
}

extension OwnerDTO {
    func toDomain() -> Owner {
        let avatarURL = URL(string: avatarURL) ?? URL(string: "https://example.com/placeholder.png")!
        return Owner(id: id, username: login, avatarURL: avatarURL)
    }
}

enum DTOError: Error {
    case dateParsingError
    case invalidURL
}
