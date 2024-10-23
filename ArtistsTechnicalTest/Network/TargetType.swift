//
//  TargetType.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// A protocol defining the requirements for a target type used in network requests.
/// Conforming types must provide the necessary information to construct a URL for requests.
protocol TargetType {
    
    /// The base URL for the API endpoint.
    /// This property should return the root URL for all requests made with this target.
    var baseURL: String { get }
    
    /// The path for the specific resource being requested.
    /// This property should return the endpoint path that will be appended to the base URL.
    var path: String { get }
    
}
