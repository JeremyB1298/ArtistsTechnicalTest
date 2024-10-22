//
//  ArtistTarget.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

/// An enumeration defining the various targets for artist-related API requests.
enum ArtistTarget {
    case search(query: String)
}

// MARK: - TargetType

extension ArtistTarget: TargetType {
    var baseURL: String {
        "https://api.artic.edu"
    }
    
    var path: String {
        switch self {
        case .search(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "/api/v1/artists/search?q=\(encodedQuery)"
        }
    }
    
}
