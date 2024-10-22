//
//  SearchArtistsTableViewDataSource.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

// MARK: - SearchArtistsTableViewDataSource

protocol SearchArtistsTableViewDataSource: UITableViewDataSource {
    var delegate: SearchArtistsTableViewCellDelegate? { get set}
    func update(with models: [ArtistUIModel])
}

// MARK: - SearchArtistsTableViewDataSourceImpl

final class SearchArtistsTableViewDataSourceImpl: NSObject, SearchArtistsTableViewDataSource {
    
    // MARK: - Private property
    
    private var models: [ArtistUIModel] = []
    
    // MARK: - Public property
    
    weak var delegate: SearchArtistsTableViewCellDelegate?
    
    // MARK: - Public methods
    
    func update(with models: [ArtistUIModel]) {
        self.models = models
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: SearchArtistsTableViewCellImpl.identifier,
                    for: indexPath
                )
                as? (UITableViewCell & SearchArtistsTableViewCell)
        else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let model = models[index]
        cell.configure(model: model)
        cell.delegate = delegate
        
        return cell
    }
    
}
