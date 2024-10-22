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
    
    private let viewModel: SearchArtistsViewModel
    private lazy var contentView: (UIView & SearchArtistsView) = {
        let view = SearchArtistsViewImpl()
        view.setDataSource(dataSource: dataSource)
        view.delegate = self
        
        return view
    }()
    private lazy var dataSource: SearchArtistsTableViewDataSource = {
        let dataSource = SearchArtistsTableViewDataSourceImpl()
        dataSource.delegate = self
        
        return dataSource
    }()
    
    // MARK: - Initializers
    
    init(viewModel: SearchArtistsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViews()
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
                    reloadData()
                case .failure(let error):
                    showAlert(error: error)
                }
            }
    }
    
    /// Reloads the data displayed in the view.
    private func reloadData() {
        let artists = viewModel.uiArtists
        dataSource.update(with: artists)
        contentView.reloadData()
    }
    
    /// Displays an alert with the provided error message.
    /// - Parameter error: The error to display.
    private func showAlert(error: AppError) {
        let message = error.localizationDescription
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "ok", style: .cancel)
        alertController.addAction(okAlertAction)
        
        present(alertController, animated: true)
    }
    
    /// Sets up the user interface properties.
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .backgroundWhite)
    }
    
    /// Sets up the views by adding them to the main view.
    private func setupViews() {
        view.addSubview(contentView)
    }
    
    /// Configures layout constraints for the content view.
    private func makeConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
        let count = viewModel.showCount
        
        switch viewModel.searchState {
        case .results:
            updateShowButtonUIForResultsState(count: count)
        case .selected:
            updateShowButtonUIForSelectedState(count: count)
        }
        updateResetUI()
        
        reloadData()
    }
    
    /// Updates the show button UI for the results state.
    /// - Parameter count: The count of selected artists.
    private func updateShowButtonUIForResultsState(count: Int) {
        let isEnabled = count != 0
        let title: String
        
        if isEnabled {
            title = "Show Selected (\(count))"
        } else {
            title = "0 Selected"
        }
        
        contentView.updateShowButtonWith(title: title, isEnabled: isEnabled)
    }
    
    /// Updates the show button UI for the selected state.
    /// - Parameter count: The count of artists in results.
    private func updateShowButtonUIForSelectedState(count: Int) {
        let title = "Show Results (\(count))"
        contentView.updateShowButtonWith(title: title, isEnabled: true)
    }
    
    /// Updates the reset button UI based on the selection state.
    private func updateResetUI() {
        let isHidden = !viewModel.isResetEnabled
        contentView.updateResetButton(isHidden: isHidden)
    }
    
    /// Updates the UI with the current search query.
    /// - Parameter query: The search query entered by the user.
    private func updateUI(with query: String) {
        resetSearchState()
        search(query: query)
    }
    
    /// Resets the search state if it is currently in selected mode.
    private func resetSearchState() {
        guard viewModel.searchState == .selected else { return }
        viewModel.switchSearchState()
        reloadUIWithCurrentState()
    }
    
    /// Handles the action to show artists.
    private func didSelectShow() {
        viewModel.switchSearchState()
        reloadUIWithCurrentState()
    }
    
    /// Resets the artist selection and updates the UI.
    private func reset() {
        viewModel.reset()
        contentView.resetSearchBar()
        reloadUIWithCurrentState()
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchArtistsViewController: SearchArtistsViewDelegate {
    
    func searchArtistsViewDidTapOnReset() {
        reset()
    }
    
    func searchArtistsView(searchBarTextDidChange text: String) {
        updateUI(with: text)
    }
    
    func searchArtistsViewDidSelectShow() {
        didSelectShow()
    }
    
}

// MARK: - SearchArtistsTableViewCellDelegate

extension SearchArtistsViewController: SearchArtistsTableViewCellDelegate {
    
    func searchArtistsTableViewCell(didSelect id: Int, isSelected: Bool) {
        viewModel.updateSelectStatus(for: id, with: isSelected)
        reloadUIWithCurrentState()
    }
    
}
