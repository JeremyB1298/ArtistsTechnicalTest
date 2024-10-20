//
//  MockTarget.swift
//  ArtistsTechnicalTestTests
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

@testable import ArtistsTechnicalTest

/// A mock implementation of the `TargetType` protocol for testing purposes.
/// This struct provides a simple way to define base URL and path for network requests in tests.
struct MockTarget: TargetType {
    var baseURL: String
    var path: String
}
