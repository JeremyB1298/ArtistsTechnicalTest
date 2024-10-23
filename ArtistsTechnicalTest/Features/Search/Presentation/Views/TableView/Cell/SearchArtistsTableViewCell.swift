//
//  SearchArtistsTableViewCell.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

/// A protocol defining the requirements for a search artist table view cell.
protocol SearchArtistsTableViewCell: AnyObject {
    
    /// The unique identifier for the cell.
    static var identifier: String { get }
    
    /// A delegate for handling selection events in the cell.
    var delegate: SearchArtistsTableViewCellDelegate? { get set}
    
    /// Configures the cell with an artist model.
    /// - Parameter model: The artist model to configure the cell.
    func configure(model: ArtistUIModel)
}

// MARK: - SearchArtistsTableViewCellDelegate

/// A protocol for handling selection events in the search artists cell.
protocol SearchArtistsTableViewCellDelegate: AnyObject {
    
    /// Notifies the delegate that an artist cell was selected or deselected.
    /// - Parameters:
    ///   - id: The ID of the artist.
    ///   - isSelected: A Boolean indicating whether the artist is selected.
    func searchArtistsTableViewCell(didSelect id: Int, isSelected: Bool)
}

// MARK: - SearchArtistsTableViewCell

/// A final implementation of the SearchArtistsTableViewCell protocol.
final class SearchArtistsTableViewCellImpl: UITableViewCell, SearchArtistsTableViewCell {
    
    // MARK: - Constants
    
    /// A collection of constants used for layout and appearance.
    private enum Constants {
        enum Padding {
            static let top = 2.5
            static let bottom = -2.5
            static let leading = 5.0
            static let trailing = -5.0
        }
    }
    
    // MARK: - Public properties
    
    /// The unique identifier for the cell.
    static let identifier = "SearchArtistsTableViewCell"
    
    /// A weak reference to the delegate that handles selection events.
    weak var delegate: SearchArtistsTableViewCellDelegate?
    
    // MARK: - Private properties
    
    /// The custom view used to display artist information and selection state.
    private lazy var searchArtistsTableViewCellView: (UIView & SearchArtistsTableViewCellView) = {
        let view = SearchArtistsTableViewCellViewImpl()
        view.delegate = self
        
        return view
    }()
    
    /// The ID of the artist represented by this cell.
    private var artistId: Int?
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsTableViewCellImpl`.
    /// This initializer sets up the cell's UI and constraints.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up UI properties
        setupUI()
        
        // Add subviews to the cell's content view
        setupViews()
        
        // Configure layout constraints for subviews
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public method
    
    /// Configures the cell with an artist model.
    /// - Parameter model: The artist model to configure the cell.
    func configure(model: ArtistUIModel) {
        
        // Get the artist ID
        let id = model.id
        
        // Store the artist ID for selection events
        artistId = id
        
        // Get the artist title
        let title = model.title
        
        // Set the title in the view
        searchArtistsTableViewCellView.setTitle(value: title)
        
        // Get the selection state
        let isSelected = model.isSelected
        
        // Update the switch state
        searchArtistsTableViewCellView.setSelection(value: isSelected)
        
        // Set the background based on selection state
        if isSelected {
            searchArtistsTableViewCellView.setSelectedBackground()
        } else {
            searchArtistsTableViewCellView.setNotSelectedBackground()
        }
    }
    
    // MARK: - Private methods
    
    /// Sets up UI properties for the cell.
    private func setupUI() {
        
        // Disable default selection style
        selectionStyle = .none
    }
    
    /// Adds subviews to the cell's content view.
    private func setupViews() {
        
        // Add the custom view as a subview
        contentView.addSubview(searchArtistsTableViewCellView)
    }
    
    /// Configures layout constraints for the subviews.
    private func makeConstraints() {
        
        // Disable autoresizing mask
        searchArtistsTableViewCellView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate(
            [
                searchArtistsTableViewCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Padding.top),
                searchArtistsTableViewCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Padding.leading),
                searchArtistsTableViewCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.Padding.trailing),
                searchArtistsTableViewCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.Padding.bottom)
            ]
        )
    }
    
}

// MARK: - SearchArtistsTableViewCellViewDelegate

extension SearchArtistsTableViewCellImpl: SearchArtistsTableViewCellViewDelegate {
    
    /// Notifies the delegate of the selection state change.
    /// - Parameter value: A Boolean indicating whether the cell is selected.
    func searchArtistsTableViewCellView(isSelected value: Bool) {
        
        // Ensure artist ID is available
        guard let artistId else { return }
        
        // Notify the delegate of the change
        delegate?.searchArtistsTableViewCell(didSelect: artistId, isSelected: value)
    }
    
}
