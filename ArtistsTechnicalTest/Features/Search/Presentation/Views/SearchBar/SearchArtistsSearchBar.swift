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
    
    /// Initializes a new instance of `SearchArtistsSearchBar`.
    /// This initializer sets up the search bar with the default properties.
    init() {
        super.init(frame: .zero)
        
        // Call the setup method to configure search bar properties
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    /// Sets up the search bar properties.
    /// This method configures the placeholder text for the search bar to guide users on its functionality.
    private func setup() {
        
        // Set the placeholder text for the search bar
        placeholder = "Search an artist name..."
    }
    
}
