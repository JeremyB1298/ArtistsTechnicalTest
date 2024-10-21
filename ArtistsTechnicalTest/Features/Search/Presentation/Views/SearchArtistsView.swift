//
//  SearchArtistsView.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

// MARK: - SearchArtistsViewDelegate

protocol SearchArtistsViewDelegate: AnyObject {
    func searchArtistsView(searchBarTextDidChange text: String)
    func searchArtistsViewDidSelectShow()
}

// MARK: - SearchArtistsView

protocol SearchArtistsView {
    var delegate: SearchArtistsViewDelegate? { get set }
    func setDataSource(dataSource: UITableViewDataSource)
    func reloadData()
    func updateShowButtonWith(title: String, isEnabled: Bool)
}

// MARK: - SearchArtistsViewImpl

final class SearchArtistsViewImpl: UIView, SearchArtistsView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum ShowButton {
            enum Padding {
                static let leading = 10.0
            }
        }
    }
    
    // MARK: - Private properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    private lazy var tableView: UITableView = SearchArtistsTableView()
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        button.setTitle("0 Selected", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.isEnabled = false
        
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
    
    func setDataSource(dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateShowButtonWith(title: String, isEnabled: Bool) {
        showButton.setTitle(title, for: .normal)
        showButton.isEnabled = isEnabled
    }
    
    // MARK: Private methods
    
    @objc private func showAction() {
        delegate?.searchArtistsViewDidSelectShow()
    }
    
    private func setupViews() {
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(showButton)
    }
    
    private func makeConstraints() {
        makeSearchBarConstraints()
        makeShowButtonConstraints()
        makeTableViewConstraints()
    }
    
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
    
    private func makeShowButtonConstraints() {
        showButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                showButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                showButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.ShowButton.Padding.leading)
            ]
        )
    }
    
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
    
}
