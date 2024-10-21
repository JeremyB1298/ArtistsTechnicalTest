//
//  SearchArtistsTableViewCell.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

final class SearchArtistsTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Padding {
            static let top = 2.5
            static let bottom = -2.5
            static let leading = 5.0
            static let trailing = -5.0
        }
    }
    
    // MARK: - Public property
    
    static let identifier = "SearchArtistsTableViewCell"
    
    // MARK: - Private property
    
    private let searchArtistsTableViewCellView: SearchArtistsTableViewCellView = SearchArtistsTableViewCellView()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public method
    
    func configure(model: ArtistUIModel) {
        let title = model.title
        searchArtistsTableViewCellView.setTitle(value: title)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        contentView.addSubview(searchArtistsTableViewCellView)
    }
    
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
