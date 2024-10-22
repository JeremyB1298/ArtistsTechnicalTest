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
    
    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private method
    
    /// Sets up the table view properties and registers cell classes.
    func setup() {
        register(SearchArtistsTableViewCellImpl.self, forCellReuseIdentifier: SearchArtistsTableViewCellImpl.identifier)
        separatorStyle = .none
    }
    
}
