//
//  SearchArtistsTableView.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

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
    
    func setup() {
        register(SearchArtistsTableViewCell.self, forCellReuseIdentifier: SearchArtistsTableViewCell.identifier)
        separatorStyle = .none
    }
}
