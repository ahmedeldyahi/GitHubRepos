//
//  NetworkServiceTests.swift
//  GitHubRepos
//
//  Created by Ahmed Eldyahi on 29/07/2025.
//

import XCTest
@testable import GitHubRepos

final class NetworkServiceTests: XCTestCase {

    struct SampleModel: Codable, Equatable {
        let id: Int
        let name: String
    }

    func testRequestReturnsDecodedModel() async throws {
        let mockSession = MockURLSession()
        let expected = SampleModel(id: 1, name: "Test")
        mockSession.mockData = try JSONEncoder().encode(expected)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let sut = NetworkService(urlSession: mockSession)
        let endpoint = Endpoint.repositories

        let result: SampleModel = try await sut.request(endpoint)

        XCTAssertEqual(result, expected)
    }

    func testRequestThrowsInvalidResponse() async {
        let mockSession = MockURLSession()
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )

        let sut = NetworkService(urlSession: mockSession)
        let endpoint = Endpoint.repositories

        do {
            let _: SampleModel = try await sut.request(endpoint)
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
}

