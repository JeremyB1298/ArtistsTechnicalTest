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
        let artist = viewModel.uiSearchArtists
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
    
    private func updateUIForResultsState() {
        let artists = viewModel.uiSearchArtists
        reloadData(artists: artists)
        let artistsSelectedCount = viewModel.uiSelectedArtists.count
        
        let isEnabled = artistsSelectedCount != 0
        let title: String
        
        if isEnabled {
            title = "Show Selected (\(artistsSelectedCount))"
        } else {
            title = "0 Selected"
        }
        
        contentView.updateShowButtonWith(title: title, isEnabled: isEnabled)
    }
    
    private func updateUIForSelectedState() {
        let resultArtistsCount = viewModel.uiSearchArtists.count
        let artists: [ArtistUIModel] = viewModel.uiSelectedArtists
        
        reloadData(artists: artists)
        
        let title = "Show Results (\(resultArtistsCount))"
        contentView.updateShowButtonWith(title: title, isEnabled: true)
    }
    
    private func reloadUIWithCurrentState() {
        switch viewModel.searchState {
        case .results:
            updateUIForResultsState()
        case .selected:
            updateUIForSelectedState()
        }
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchArtistsViewController: SearchArtistsViewDelegate {
    
    func searchArtistsView(searchBarTextDidChange text: String) {
        if viewModel.searchState == .selected {
            viewModel.switchSearchState()
            reloadUIWithCurrentState()
        }
        let query = text
        search(query: query)
    }
    
    func searchArtistsViewDidSelectShow() {
        viewModel.switchSearchState()
        reloadUIWithCurrentState()
    }
    
}

// MARK: - SearchArtistsTableViewCellDelegate

extension SearchArtistsViewController: SearchArtistsTableViewCellDelegate {
    
    func searchArtistsTableViewCell(didSelect id: Int, isSelected: Bool) {
        viewModel.updateSelectStatus(for: id, with: isSelected)
        reloadUIWithCurrentState()
    }
    
}
