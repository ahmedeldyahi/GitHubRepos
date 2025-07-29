//
//  DetailRow.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//

import SwiftUI

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(value)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                Spacer()
                
                if title == "GitHub URL" {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.blue)
                }
            }
            .padding(12)
            
            if !isLast {
                Divider().padding(.leading, 52)
            }
        }
    }
}
