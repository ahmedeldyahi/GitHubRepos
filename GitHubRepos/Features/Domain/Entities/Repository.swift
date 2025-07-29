//
//  Repository.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//
import Foundation

struct Repository: Identifiable {
    let id: Int
    let name: String
    let owner: Owner
    let createdAt: Date
    let htmlURL: URL
}
