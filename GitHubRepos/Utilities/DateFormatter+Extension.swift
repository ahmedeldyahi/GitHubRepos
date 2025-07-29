//
//  DateFormatter+Extension.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 28/07/2025.
//

import Foundation
extension DateFormatter {
    static let repositoryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static func relativeOrFormattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if let monthsAgo = calendar.dateComponents([.month], from: date, to: now).month,
           monthsAgo < 6 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            return formatter.string(from: date)
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: date, relativeTo: now)
        }
    }
}
