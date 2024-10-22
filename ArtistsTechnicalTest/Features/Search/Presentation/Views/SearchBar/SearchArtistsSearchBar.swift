//
//  SearchArtistsSearchBar.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

/// A custom search bar for searching artists.
final class SearchArtistsSearchBar: UISearchBar {
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    /// Sets up the search bar properties.
    private func setup() {
        placeholder = "Search an artist name..."
    }
    
}
