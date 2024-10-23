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
    
    /// Notifies the delegate that the search bar text has changed.
    /// - Parameter text: The new text from the search bar.
    func searchArtistsView(searchBarTextDidChange text: String)
    
    /// Notifies the delegate when the show button is selected.
    func searchArtistsViewDidSelectShow()
    
    /// Notifies the delegate when the reset button is tapped.
    func searchArtistsViewDidTapOnReset()
}

// MARK: - SearchArtistsView

/// A protocol defining the requirements for a search artists view.
protocol SearchArtistsView {
    
    /// A delegate that receives events related to search artists actions.
    var delegate: SearchArtistsViewDelegate? { get set }
    
    /// Sets the data source for the table view.
    /// - Parameter dataSource: The data source for the table view.
    func setDataSource(dataSource: UITableViewDataSource)
    
    /// Reloads the table view data.
    func reloadData()
    
    /// Updates the show button with a title and enables or disables it.
    /// - Parameters:
    ///   - title: The title to display on the show button.
    ///   - isEnabled: A Boolean indicating whether the button should be enabled.
    func updateShowButtonWith(title: String, isEnabled: Bool)
    
    /// Updates the visibility of the reset button.
    /// - Parameter isHidden: A Boolean indicating whether the reset button should be hidden.
    func updateResetButton(isHidden: Bool)
    
    /// Resets the search bar text.
    func resetSearchBar()
}

// MARK: - SearchArtistsViewImpl

/// A final implementation of the SearchArtistsView protocol.
/// This class represents the view for searching artists.
final class SearchArtistsViewImpl: UIView, SearchArtistsView {
    
    // MARK: - Constants
    
    /// A collection of constants used for layout and appearance.
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
    
    /// The search bar used for entering artist names.
    private lazy var searchBar: UISearchBar = {
        let searchBar = SearchArtistsSearchBar()
        // Set the view as the delegate
        searchBar.delegate = self
        
        return searchBar
    }()
    
    /// The table view for displaying search results.
    private lazy var tableView: UITableView = SearchArtistsTableView()
    
    /// The button for displaying selected artists.
    private lazy var showButton: UIButton = {
        let button = SearchArtistsShowButton()
        
        // Add target for button action
        button.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        
        // Initially disabled
        button.isEnabled = false
        
        return button
    }()
    
    /// The button for resetting the search.
    private lazy var resetButton: UIButton = {
        let button = SearchArtistsResetButton()
        
        // Add target for button action
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        // Initially hidden
        button.isHidden = true
        
        return button
    }()
    
    // MARK: - Public property
    
    /// A weak reference to the delegate that handles search artists events.
    weak var delegate: SearchArtistsViewDelegate?
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsViewImpl`.
    /// This initializer sets up the view and its subviews.
    init() {
        super.init(frame: .zero)
        
        // Add subviews to the main view
        setupViews()
        
        // Configure layout constraints for subviews
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public method
    
    /// Sets the data source for the table view.
    /// - Parameter dataSource: The data source for the table view.
    func setDataSource(dataSource: UITableViewDataSource) {
        
        // Assign the data source to the table view
        tableView.dataSource = dataSource
    }
    
    /// Reloads the table view data.
    func reloadData() {
        
        // Reload the table view's data
        tableView.reloadData()
    }
    
    /// Updates the show button with a title and enables or disables it.
    /// - Parameters:
    ///   - title: The title to display on the show button.
    ///   - isEnabled: A Boolean indicating whether the button should be enabled.
    func updateShowButtonWith(title: String, isEnabled: Bool) {
        
        // Set the title for the button
        showButton.setTitle(title, for: .normal)
        
        // Enable or disable the button
        showButton.isEnabled = isEnabled
    }
    
    /// Updates the visibility of the reset button.
    /// - Parameter isHidden: A Boolean indicating whether the reset button should be hidden.
    func updateResetButton(isHidden: Bool) {
        
        // Set the hidden state of the reset button
        resetButton.isHidden = isHidden
    }
    
    /// Resets the search bar text.
    func resetSearchBar() {
        
        // Clear the search bar text
        searchBar.text = nil
    }
    
    // MARK: Private methods
    
    /// Called when the reset button is tapped.
    @objc private func reset() {
        
        // Notify the delegate of the reset action
        delegate?.searchArtistsViewDidTapOnReset()
    }
    
    /// Called when the show button is tapped.
    @objc private func showAction() {
        
        // Notify the delegate to show selected artists
        delegate?.searchArtistsViewDidSelectShow()
    }
    
    /// Sets up the views.
    private func setupViews() {
        
        // Add the search bar
        addSubview(searchBar)
        
        // Add the table view
        addSubview(tableView)
        
        // Add the show button
        addSubview(showButton)
        
        // Add the reset button
        addSubview(resetButton)
    }
    
    /// Sets up the constraints for the views.
    private func makeConstraints() {
        
        // Set constraints for the search bar
        makeSearchBarConstraints()
        
        // Set constraints for the show button
        makeShowButtonConstraints()
        
        // Set constraints for the reset button
        makeResetButtonConstraints()
        
        // Set constraints for the table view
        makeTableViewConstraints()
    }
    
    /// Sets constraints for the search bar.
    private func makeSearchBarConstraints() {
        
        // Disable autoresizing mask
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
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
        
        // Disable autoresizing mask
        showButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate(
            [
                showButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                showButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.ShowButton.Padding.leading)
            ]
        )
    }
    
    /// Sets constraints for the reset button.
    private func makeResetButtonConstraints() {
        
        // Disable autoresizing mask
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
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
        
        // Disable autoresizing mask
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
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
    
    /// Called when the search bar text changes.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Notify the delegate of the text change
        delegate?.searchArtistsView(searchBarTextDidChange: searchText)
    }
    
    /// Called when the search button is clicked in the search bar.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }
    
}
