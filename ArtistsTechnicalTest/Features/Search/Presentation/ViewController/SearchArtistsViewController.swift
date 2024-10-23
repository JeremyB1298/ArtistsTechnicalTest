//
//  SearchArtistsViewController.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

/// A view controller that displays a search interface for artists.
/// This class handles user interactions and displays the results based on the search state.
final class SearchArtistsViewController: UIViewController {
    
    // MARK: - Private properties
    
    /// The view model that manages the search artists logic and data.
    private let viewModel: SearchArtistsViewModel
    
    /// The main content view that represents the search artists interface.
    private lazy var contentView: (UIView & SearchArtistsView) = {
        let view = SearchArtistsViewImpl()
        
        // Set the data source for the content view
        view.setDataSource(dataSource: dataSource)
        
        // Set the delegate for the content view
        view.delegate = self
        
        return view
    }()
    
    /// The data source for the table view, managing artist display.
    private lazy var dataSource: (UITableViewDataSource & SearchArtistsTableViewDataSource) = {
        let dataSource = SearchArtistsTableViewDataSourceImpl()
        
        // Set the delegate for the data source
        dataSource.delegate = self
        
        return dataSource
    }()
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsViewController`.
    /// - Parameter viewModel: The view model that provides data and logic for the search artists view.
    init(viewModel: SearchArtistsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    /// Called after the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up user interface properties
        setupUI()
        
        // Add subviews to the main view
        setupViews()
        
        // Configure layout constraints for subviews
        makeConstraints()
    }
    
    // MARK: - Private methods
    
    /// Performs a search with the provided query.
    /// - Parameter query: The search query entered by the user.
    private func search(query: String) {
        viewModel
            .search(query: query) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success():
                    
                    // Reload data on successful search
                    reloadData()
                case .failure(let error):
                    
                    // Show an alert on error
                    showAlert(error: error)
                }
            }
    }
    
    /// Reloads the data displayed in the view.
    private func reloadData() {
        
        // Get the updated artist models
        let artists = viewModel.uiArtists
        
        // Update the data source with new models
        dataSource.update(with: artists)
        
        // Reload the content view
        contentView.reloadData()
    }
    
    /// Displays an alert with the provided error message.
    /// - Parameter error: The error to display.
    private func showAlert(error: AppError) {
        
        // Get the error message
        let message = error.localizationDescription
        
        // Create alert controller
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // Create OK action
        let okAlertAction = UIAlertAction(title: "ok", style: .cancel)
        
        // Add action to alert
        alertController.addAction(okAlertAction)
        
        // Present the alert
        present(alertController, animated: true)
    }
    
    /// Sets up the user interface properties.
    private func setupUI() {
        
        // Set the background color
        view.backgroundColor = UIColor(resource: .backgroundWhite)
    }
    
    /// Sets up the views by adding them to the main view.
    private func setupViews() {
        
        // Add the content view
        view.addSubview(contentView)
    }
    
    /// Configures layout constraints for the content view.
    private func makeConstraints() {
        
        // Disable autoresizing mask
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate(
            [
                contentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    /// Updates the UI based on the current search state.
    private func reloadUIWithCurrentState() {
        
        // Get the count of selected artists
        let count = viewModel.showCount
        
        switch viewModel.searchState {
        case .results:
            
            // Update show button UI for results state
            updateShowButtonUIForResultsState(count: count)
        case .selected:
            
            // Update show button UI for selected state
            updateShowButtonUIForSelectedState(count: count)
        }
        
        // Update reset button UI
        updateResetUI()
        
        // Reload data to reflect current state
        reloadData()
    }
    
    /// Updates the show button UI for the results state.
    /// - Parameter count: The count of selected artists.
    private func updateShowButtonUIForResultsState(count: Int) {
        // Determine if the button should be enabled
        let isEnabled = count != 0
        let title: String
        
        if isEnabled {
            
            // Set title for enabled state
            title = "Show Selected (\(count))"
        } else {
            
            // Set title for disabled state
            title = "0 Selected"
        }
        
        // Update the show button
        contentView.updateShowButtonWith(title: title, isEnabled: isEnabled)
    }
    
    /// Updates the show button UI for the selected state.
    /// - Parameter count: The count of artists in results.
    private func updateShowButtonUIForSelectedState(count: Int) {
        
        // Set title for selected state
        let title = "Show Results (\(count))"
        
        // Update the show button
        contentView.updateShowButtonWith(title: title, isEnabled: true)
    }
    
    /// Updates the reset button UI based on the selection state.
    private func updateResetUI() {
        
        // Determine if the reset button should be hidden
        let isHidden = !viewModel.isResetEnabled
        
        // Update the reset button
        contentView.updateResetButton(isHidden: isHidden)
    }
    
    /// Updates the UI with the current search query.
    /// - Parameter query: The search query entered by the user.
    private func updateUI(with query: String) {
        
        // Reset the search state if needed
        resetSearchState()
        
        // Perform the search
        search(query: query)
    }
    
    /// Resets the search state if it is currently in selected mode.
    private func resetSearchState() {
        
        // Only reset if currently in selected state
        guard viewModel.searchState == .selected else { return }
        
        // Switch the search state
        viewModel.switchSearchState()
        
        // Reload the UI
        reloadUIWithCurrentState()
    }
    
    /// Handles the action to show artists.
    private func didSelectShow() {
        
        // Switch the search state
        viewModel.switchSearchState()
        
        // Reload the UI
        reloadUIWithCurrentState()
    }
    
    /// Resets the artist selection and updates the UI.
    private func reset() {
        
        // Reset the view model state
        viewModel.reset()
        
        // Clear the search bar
        contentView.resetSearchBar()
        
        // Reload the UI
        reloadUIWithCurrentState()
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchArtistsViewController: SearchArtistsViewDelegate {
    
    /// Called when the reset button is tapped.
    func searchArtistsViewDidTapOnReset() {
        
        // Handle reset action
        reset()
    }
    
    /// Called when the search bar text changes.
    /// - Parameter text: The new text from the search bar.
    func searchArtistsView(searchBarTextDidChange text: String) {
        
        // Update UI with new search query
        updateUI(with: text)
    }
    
    /// Called when the show button is selected.
    func searchArtistsViewDidSelectShow() {
        
        // Handle show action
        didSelectShow()
    }
    
}

// MARK: - SearchArtistsTableViewCellDelegate

extension SearchArtistsViewController: SearchArtistsTableViewCellDelegate {
    
    /// Called when an artist cell is selected or deselected.
    /// - Parameters:
    ///   - id: The ID of the artist.
    ///   - isSelected: A Boolean indicating whether the artist is selected.
    func searchArtistsTableViewCell(didSelect id: Int, isSelected: Bool) {
        
        // Update selection status in the view model
        viewModel.updateSelectStatus(for: id, with: isSelected)
        
        // If the search state is currently selected and the artist list is empty, switch back to results
        if
            viewModel.searchState == .selected,
            viewModel.uiArtists.isEmpty 
        {
            // Switch the state to results
            viewModel.switchSearchState()
        }
        
        // Reload the UI to reflect changes
        reloadUIWithCurrentState()
    }
    
}
