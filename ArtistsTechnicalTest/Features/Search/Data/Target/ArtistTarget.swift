//
//  ArtistTarget.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 19/10/2024.
//

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
            return "/api/v1/artists/search?q={\(query)}"
        }
    }
    
}
