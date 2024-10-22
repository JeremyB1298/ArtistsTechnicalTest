//
//  SearchArtistsTableViewCell.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

/// A protocol defining the requirements for a search artist table view cell.
protocol SearchArtistsTableViewCell: AnyObject {
    static var identifier: String { get }
    var delegate: SearchArtistsTableViewCellDelegate? { get set}
    
    /// Configures the cell with an artist model.
    /// - Parameter model: The artist model to configure the cell.
    func configure(model: ArtistUIModel)
}

// MARK: - SearchArtistsTableViewCellDelegate

/// A protocol for handling selection events in the search artists cell.
protocol SearchArtistsTableViewCellDelegate: AnyObject {
    func searchArtistsTableViewCell(didSelect id: Int, isSelected: Bool)
}

// MARK: - SearchArtistsTableViewCell

/// A final implementation of the SearchArtistsTableViewCell protocol.
final class SearchArtistsTableViewCellImpl: UITableViewCell, SearchArtistsTableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Padding {
            static let top = 2.5
            static let bottom = -2.5
            static let leading = 5.0
            static let trailing = -5.0
        }
    }
    
    // MARK: - Public properties
    
    static let identifier = "SearchArtistsTableViewCell"
    weak var delegate: SearchArtistsTableViewCellDelegate?
    
    // MARK: - Private properties
    
    private lazy var searchArtistsTableViewCellView: (UIView & SearchArtistsTableViewCellView) = {
        let view = SearchArtistsTableViewCellViewImpl()
        view.delegate = self
        
        return view
    }()
    private var artistId: Int?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public method
    
    /// Configures the cell with an artist model.
    /// - Parameter model: The artist model to configure the cell.
    func configure(model: ArtistUIModel) {
        let id = model.id
        artistId = id
        let title = model.title
        searchArtistsTableViewCellView.setTitle(value: title)
        
        let isSelected = model.isSelected
        searchArtistsTableViewCellView.setSelection(value: isSelected)
        
        if isSelected {
            searchArtistsTableViewCellView.setSelectedBackground()
        } else {
            searchArtistsTableViewCellView.setNotSelectedBackground()
        }
    }
    
    // MARK: - Private methods
    
    /// Sets up UI properties for the cell.
    private func setupUI() {
        selectionStyle = .none
    }
    
    /// Adds subviews to the cell's content view.
    private func setupViews() {
        contentView.addSubview(searchArtistsTableViewCellView)
    }
    
    /// Configures layout constraints for the subviews.
    private func makeConstraints() {
        searchArtistsTableViewCellView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func searchArtistsTableViewCellView(isSelected value: Bool) {
        guard let artistId else { return }
        delegate?.searchArtistsTableViewCell(didSelect: artistId, isSelected: value)
    }
    
}
