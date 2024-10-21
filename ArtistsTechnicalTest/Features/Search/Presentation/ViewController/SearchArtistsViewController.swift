//
//  SearchArtistsViewController.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

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
    
    private func search(query: String) {
        viewModel
            .search(query: query) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success():
                    searchOnSuccess()
                case .failure(let error):
                    showAlert(error: error)
                }
            }
    }
    
    private func searchOnSuccess() {
        let artist = viewModel.uiArtists
        reloadData(artists: artist)
    }
    
    private func reloadData(artists: [ArtistUIModel]) {
        let artists = artists
        dataSource.update(with: artists)
        contentView.reloadData()
    }
    
    private func showAlert(error: AppError) {
        let message: String
        
        switch error {
        case .invalidURL(let string),
                .badResponse(let string),
                .decodingError(let string),
                .networkError(let string):
            message = string
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "ok", style: .cancel)
        alertController.addAction(okAlertAction)
        
        present(alertController, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .backgroundWhite)
    }
    
    private func setupViews() {
        view.addSubview(contentView)
    }
    
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
    
    private func reloadUIWithCurrentState() {
        let count = viewModel.showCount
        let artists = viewModel.uiArtists
        
        switch viewModel.searchState {
        case .results:
            updateUIForResultsState(count: count, artists: artists)
        case .selected:
            updateUIForSelectedState(count: count, artists: artists)
        }
    }
    
    private func updateUIForResultsState(count: Int, artists: [ArtistUIModel]) {
        reloadData(artists: artists)
        
        let isEnabled = count != 0
        let title: String
        
        if isEnabled {
            title = "Show Selected (\(count))"
        } else {
            title = "0 Selected"
        }
        
        contentView.updateShowButtonWith(title: title, isEnabled: isEnabled)
    }
    
    private func updateUIForSelectedState(count: Int, artists: [ArtistUIModel]) {
        reloadData(artists: artists)
        
        let title = "Show Results (\(count))"
        contentView.updateShowButtonWith(title: title, isEnabled: true)
    }
    
    private func updateUI(with query: String) {
        resetSearchState()
        search(query: query)
    }
    
    private func resetSearchState() {
        guard viewModel.searchState == .selected else { return }
        viewModel.switchSearchState()
        reloadUIWithCurrentState()
    }
    
    private func didSelectShow() {
        viewModel.switchSearchState()
        reloadUIWithCurrentState()
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchArtistsViewController: SearchArtistsViewDelegate {
    
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
