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
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    private lazy var tableView: UITableView = {
        let tableView = SearchArtistsTableView()
        tableView.dataSource = dataSource
        
        return tableView
    }()
    private let dataSource: SearchArtistsTableViewDataSource
    
    // MARK: - Initializers
    
    init(viewModel: SearchArtistsViewModel) {
        self.viewModel = viewModel
        dataSource = SearchArtistsTableViewDataSourceImpl()
        
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
                case .success(let artists):
                    searchOnSuccess(artists: artists)
                case .failure(let error):
                    showAlert(error: error)
                }
            }
    }
    
    private func searchOnSuccess(artists: [ArtistUIModel]) {
        dataSource.update(with: artists)
        tableView.reloadData()
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
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func makeConstraints() {
        makeSearchBarConstraints()
        makeTableViewConstraints()
    }
    
    private func makeSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
    
    private func makeTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
}

// MARK: - UISearchBarDelegate

extension SearchArtistsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchText
        search(query: query)
    }
    
}
