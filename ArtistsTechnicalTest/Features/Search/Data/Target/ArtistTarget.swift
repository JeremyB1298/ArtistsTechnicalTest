//
//  ArtistTarget.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// An enumeration defining the various targets for artist-related API requests.
enum ArtistTarget {
    /// Represents a search request for artists with a given query.
    case search(query: String)
}

// MARK: - TargetType

extension ArtistTarget: TargetType {
    /// The base URL for the API.
    var baseURL: String {
        // Return the base URL for the API
        "https://api.artic.edu"
    }
    
    /// The path for the specific API request based on the target.
    var path: String {
        switch self {
        case .search(let query):
            // Encode the query to ensure it is a valid URL string
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            // Return the complete path for the search request
            return "/api/v1/artists/search?q=\(encodedQuery)"
        }
    }
    
}
