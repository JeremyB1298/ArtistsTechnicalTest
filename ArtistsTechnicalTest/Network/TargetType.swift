//
//  TargetType.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A protocol defining the requirements for a target type used in network requests.
/// Conforming types must provide the necessary information to construct a URL for requests.
protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
}
