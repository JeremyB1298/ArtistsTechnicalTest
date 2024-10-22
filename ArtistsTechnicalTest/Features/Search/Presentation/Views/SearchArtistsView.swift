//
//  SearchArtistsView.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

// MARK: - SearchArtistsViewDelegate

/// A protocol defining the delegate methods for the search artists view.
protocol SearchArtistsViewDelegate: AnyObject {
    func searchArtistsView(searchBarTextDidChange text: String)
    func searchArtistsViewDidSelectShow()
    func searchArtistsViewDidTapOnReset()
}

// MARK: - SearchArtistsView

/// A protocol defining the requirements for a search artists view.
protocol SearchArtistsView {
    var delegate: SearchArtistsViewDelegate? { get set }
    func setDataSource(dataSource: UITableViewDataSource)
    func reloadData()
    func updateShowButtonWith(title: String, isEnabled: Bool)
    func updateResetButton(isHidden: Bool)
    func resetSearchBar()
}

// MARK: - SearchArtistsViewImpl

/// A final implementation of the SearchArtistsView protocol.
/// This class represents the view for searching artists.
final class SearchArtistsViewImpl: UIView, SearchArtistsView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum ShowButton {
            enum Padding {
                static let leading = 10.0
            }
        }
        enum ResetButton {
            enum Padding {
                static let trailing = -10.0
            }
        }
    }
    
    // MARK: - Private properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = SearchArtistsSearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    private lazy var tableView: UITableView = SearchArtistsTableView()
    private lazy var showButton: UIButton = {
        let button = SearchArtistsShowButton()
        button.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    private lazy var resetButton: UIButton = {
        let button = SearchArtistsResetButton()
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    // MARK: - Public property
    
    weak var delegate: SearchArtistsViewDelegate?
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public method
    
    /// Sets the data source for the table view.
    func setDataSource(dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    /// Reloads the table view data.
    func reloadData() {
        tableView.reloadData()
    }
    
    /// Updates the show button with a title and enables or disables it.
    func updateShowButtonWith(title: String, isEnabled: Bool) {
        showButton.setTitle(title, for: .normal)
        showButton.isEnabled = isEnabled
    }
    
    /// Updates the visibility of the reset button.
    func updateResetButton(isHidden: Bool) {
        resetButton.isHidden = isHidden
    }
    
    /// Resets the search bar text.
    func resetSearchBar() {
        searchBar.text = nil
    }
    
    // MARK: Private methods
    
    @objc private func reset() {
        delegate?.searchArtistsViewDidTapOnReset()
    }
    
    @objc private func showAction() {
        delegate?.searchArtistsViewDidSelectShow()
    }
    
    /// Sets up the views.
    private func setupViews() {
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(showButton)
        addSubview(resetButton)
    }
    
    /// Sets up the constraints for the views.
    private func makeConstraints() {
        makeSearchBarConstraints()
        makeShowButtonConstraints()
        makeResetButtonConstraints()
        makeTableViewConstraints()
    }
    
    /// Sets constraints for the search bar.
    private func makeSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                searchBar.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
    
    /// Sets constraints for the show button.
    private func makeShowButtonConstraints() {
        showButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                showButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                showButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.ShowButton.Padding.leading)
            ]
        )
    }
    
    /// Sets constraints for the reset button.
    private func makeResetButtonConstraints() {
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                resetButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                resetButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.ResetButton.Padding.trailing),
                resetButton.bottomAnchor.constraint(equalTo: showButton.bottomAnchor)
            ]
        )
    }
    
    /// Sets constraints for the table view.
    private func makeTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: showButton.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
}

// MARK: - SearchArtistsViewImpl

extension SearchArtistsViewImpl: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchArtistsView(searchBarTextDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
