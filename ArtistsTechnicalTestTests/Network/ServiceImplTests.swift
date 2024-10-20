//
//  ServiceImplTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 18/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

/// A test case class for testing the `ServiceImpl` implementation of the `Service` protocol.
/// This class verifies that the service correctly handles network requests and responses.
final class ServiceImplTests: XCTestCase {
    
    // MARK: - Private property
    
    private var sut: Service!
    
    // MARK: - Setup
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut = ServiceImpl(session: urlSession)
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests the `load` method of the service when the response contains valid data.
    func test_fetch_with_results() async {
        let mockTarget = MockTarget(baseURL: "https://example.com", path: "/data")
        let expectedData = MockDecodableType()
        
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            XCTAssertEqual(url.absoluteString, "https://example.com/data")
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try JSONEncoder().encode(expectedData)
            return (response, data)
        }
        do {
            let _: MockDecodableType = try await sut.load(target: mockTarget)
        } catch let error {
            XCTFail("Expected successful load, but got error: \(error)")
        }
    }
    
    /// Tests the `load` method of the service when the response contains invalid JSON data.
    func test_fetch_with_bad_Decoding() async {
        let mockTarget = MockTarget(baseURL: "https://example.com", path: "/data")
        let invalidJsonData = "{ invalid json }".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let url = request.url!
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, invalidJsonData)
        }
        
        do {
            let _: MockDecodableType = try await sut.load(target: mockTarget)
            XCTFail("Expected decoding error, but the call succeeded.")
        } catch let error as ServiceError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("Expected decoding error, but got different error => \(error)")
            }
        } catch {
            XCTFail("Expected ServiceError, but got different error: \(error)")
        }
    }
    
}
