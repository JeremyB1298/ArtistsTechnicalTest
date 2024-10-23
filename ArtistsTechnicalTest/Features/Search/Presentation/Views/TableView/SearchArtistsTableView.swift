//
//  SearchArtistsTableView.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

/// A custom table view for displaying search artists.
final class SearchArtistsTableView: UITableView {
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsTableView`.
    /// This initializer sets up the table view with a plain style.
    init() {
        super.init(frame: .zero, style: .plain)
        
        // Call the setup method to configure table view properties
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    /// Sets up the table view properties and registers cell classes.
    /// This method configures the table view by registering the custom cell class and
    /// setting the separator style.
    func setup() {
        
        // Register the custom cell class
        register(SearchArtistsTableViewCellImpl.self, forCellReuseIdentifier: SearchArtistsTableViewCellImpl.identifier)
        
        // Disable the default separator style
        separatorStyle = .none
    }
    
}
