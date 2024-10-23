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
protocol SearchArtistsTableViewDataSource {
    
    /// A delegate that receives events related to cell selection.
    var delegate: SearchArtistsTableViewCellDelegate? { get set}
    
    /// Updates the data source with the provided artist models.
    /// - Parameter models: An array of `ArtistUIModel` objects to be displayed in the table view.
    func update(with models: [ArtistUIModel])
}

// MARK: - SearchArtistsTableViewDataSourceImpl

/// A final implementation of the SearchArtistsTableViewDataSource protocol.
/// This class manages the data for the search artists table view.
final class SearchArtistsTableViewDataSourceImpl: NSObject, SearchArtistsTableViewDataSource {
    
    // MARK: - Private property
    
    /// The array of artist models used as the data source for the table view.
    private var models: [ArtistUIModel] = []
    
    // MARK: - Public property
    
    /// A weak reference to the delegate that handles cell selection events.
    weak var delegate: SearchArtistsTableViewCellDelegate?
    
    // MARK: - Public methods
    
    /// Updates the data source with the provided artist models.
    /// - Parameter models: An array of `ArtistUIModel` objects to be displayed in the table view.
    func update(with models: [ArtistUIModel]) {
        self.models = models
    }
    
}

// MARK: - UITableViewDataSource

extension SearchArtistsTableViewDataSourceImpl: UITableViewDataSource {
    
    /// Returns the number of rows in the specified section of the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the count of artist models
        models.count
    }
    
    /// Provides a cell object for the specified row in the table view.
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
        
        // Retrieve the model for the current row
        let model = models[index]
        
        // Configure the cell with the artist model
        cell.configure(model: model)
        
        // Assign the delegate to handle cell selection
        cell.delegate = delegate
        
        // Return the configured cell
        return cell
    }
    
}
