//
//  ServiceTests.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 18/10/2024.
//

import XCTest
@testable import ArtistsTechnicalTest

final class ServiceTests: XCTestCase {
    
    // MARK: - Private property
    
    private var sut: Service!
    
    // MARK: - Setup
    
    override func setUp() {
        sut = ServiceImpl()
        super.setUp()
    }
    
    // MARK: - TearDown
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_fetch_with_results() async {
        let query = "Mon"
        let target = ArtistTarget.fetch(query: query)
        
        do {
            let _: ArtistDTO = try await sut.load(target: target)
        } catch let error {
            XCTFail("test_fetch_with_results, error => \(error)")
        }
    }
    
    func test_fetch_with_bad_Decoding() async {
        let query = "Mon"
        let target = ArtistTarget.fetch(query: query)
        
        do {
            let _: String = try await sut.load(target: target)
            XCTFail("test_fetch_with_bad_Decoding, decode works with String")
        } catch let error as ServiceError {
            switch error {
            case .decodingError:
                break
            default:
                XCTFail("test_fetch_with_bad_Decoding, wrong error => \(error)")
            }
        } catch let error {
            XCTFail("test_fetch_with_bad_Decoding, error unknown => \(error)")
        }
    }
    
}

// MARK: - Models

private enum ArtistTarget {
    case fetch(query: String)
}

extension ArtistTarget: Target {
    
    var baseURL: String {
        "https://api.artic.edu"
    }
    
    var path: String {
        switch self {
        case .fetch(let query):
            return "/api/v1/artists/search?q={\(query)}"
        }
    }
    
}

private struct ArtistDTO: Decodable {
}
