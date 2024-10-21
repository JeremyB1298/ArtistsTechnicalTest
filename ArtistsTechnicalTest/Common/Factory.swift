//
//  Factory.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

// MARK: - Factory

protocol Factory {
    func makeSearchArtistsViewController() -> UIViewController
}

// MARK: - FactoryImpl

final class FactoryImpl: Factory {
    
    // MARK: - Private properties
    
    private let service: Service = ServiceImpl()
    private let artistMapper: ArtistMapper = ArtistMapper()
    private let errorMapper: ErrorMapper = ErrorMapper()
    private let dataStore: ArtistDataStore = ArtistDataStoreImpl()
    private let artistUIMapper: ArtistUIMapper = ArtistUIMapper()
    
    // MARK: - Public method
    
    func makeSearchArtistsViewController() -> UIViewController {
        let viewModel = makeSearchArtistsViewModel()
        
        return SearchArtistsViewController(viewModel: viewModel)
    }
    
    // MARK: - Private methods
    
    private func makeSearchArtistsViewModel() -> SearchArtistsViewModel {
        let searchArtistsUseCase = makeSearchArtistsUseCase()
        return SearchArtistsViewModelImpl(searchArtistsUseCase: searchArtistsUseCase, mapper: artistUIMapper)
    }
    
    private func makeSearchArtistsUseCase() -> SearchArtistsUseCase {
        let repository = makeArtistRepository()
        return SearchArtistsUseCaseImpl(repository: repository)
    }
    
    private func makeArtistRepository() -> ArtistRepository {
        ArtistRepositoryImpl(
            service: service,
            artistMapper: artistMapper,
            errorMapper: errorMapper,
            dataStore: dataStore
        )
    }
    
}
