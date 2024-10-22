//
//  SearchArtistsTableViewDataSource.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

// MARK: - SearchArtistsTableViewDataSource

/// A protocol defining the requirements for the data source of the search artists table view.
/// It extends the UITableViewDataSource protocol to include a delegate for cell selection.
protocol SearchArtistsTableViewDataSource: UITableViewDataSource {
    var delegate: SearchArtistsTableViewCellDelegate? { get set}
    func update(with models: [ArtistUIModel])
}

// MARK: - SearchArtistsTableViewDataSourceImpl

/// A final implementation of the SearchArtistsTableViewDataSource protocol.
/// This class manages the data for the search artists table view.
final class SearchArtistsTableViewDataSourceImpl: NSObject, SearchArtistsTableViewDataSource {
    
    // MARK: - Private property
    
    private var models: [ArtistUIModel] = []
    
    // MARK: - Public property
    
    weak var delegate: SearchArtistsTableViewCellDelegate?
    
    // MARK: - Public methods
    
    /// Updates the data source with the provided artist models.
    /// - Parameter models: An array of ArtistUIModel objects.
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
            fatalError("Failed to dequeue a cell with identifier: \(SearchArtistsTableViewCellImpl.identifier)")
        }
        
        let index = indexPath.row
        let model = models[index]
        cell.configure(model: model)
        cell.delegate = delegate
        
        return cell
    }
    
}
