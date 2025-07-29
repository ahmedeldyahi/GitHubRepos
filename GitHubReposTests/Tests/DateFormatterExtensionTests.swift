//
//  DateFormatterExtensionTests.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//

import XCTest
@testable import GitHubRepos

final class DateFormatterExtensionTests: XCTestCase {
    
    func testRelativeOrFormattedDate_LessThanSixMonths_ReturnsFormattedDate() {
        // Given: a date 2 months ago
        let calendar = Calendar.current
        guard let testDate = calendar.date(byAdding: .month, value: -2, to: Date()) else {
            XCTFail("Failed to create test date")
            return
        }
        
        // When
        let result = DateFormatter.relativeOrFormattedDate(from: testDate)
        
        // Then: should match exact format
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let expected = formatter.string(from: testDate)
        
        XCTAssertEqual(result, expected)
    }

    func testRelativeOrFormattedDate_MoreThanSixMonths_ReturnsRelativeDate() {
        // Given: a date 9 months ago
        let calendar = Calendar.current
        guard let testDate = calendar.date(byAdding: .month, value: -9, to: Date()) else {
            XCTFail("Failed to create test date")
            return
        }
        
        // When
        let result = DateFormatter.relativeOrFormattedDate(from: testDate)
        
        // Then: should be a relative string like "9 months ago"
        XCTAssertTrue(result.contains("ago"), "Expected relative description like '9 months ago', got '\(result)'")
    }

    func testRelativeOrFormattedDate_Today_ReturnsTodayFormatted() {
        // Given: today
        let today = Date()
        
        // When
        let result = DateFormatter.relativeOrFormattedDate(from: today)
        
        // Then
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let expected = formatter.string(from: today)
        
        XCTAssertEqual(result, expected)
    }
}
