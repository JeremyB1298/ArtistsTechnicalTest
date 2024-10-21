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
    private lazy var artistRepository: ArtistRepository = ArtistRepositoryImpl(
        service: service,
        artistMapper: artistMapper,
        errorMapper: errorMapper,
        dataStore: dataStore
    )
    
    // MARK: - Public method
    
    func makeSearchArtistsViewController() -> UIViewController {
        let viewModel = makeSearchArtistsViewModel()
        
        return SearchArtistsViewController(viewModel: viewModel)
    }
    
    // MARK: - Private methods
    
    private func makeSearchArtistsViewModel() -> SearchArtistsViewModel {
        let searchArtistsUseCase = makeSearchArtistsUseCase()
        let selectArtistUseCase = makeSelectArtistUseCase()
        let deselectArtistUseCase = makeDeselectArtistUseCase()
        let fetchSelectedArtistsUseCase = makeFetchSelectedArtistsUseCase()
        let resetSelectedArtistsUseCase = makeResetSelectedArtistsUseCase()
        
        return SearchArtistsViewModelImpl(
            searchArtistsUseCase: searchArtistsUseCase,
            mapper: artistUIMapper,
            selectArtistUseCase: selectArtistUseCase,
            deselectArtistUseCase: deselectArtistUseCase,
            fetchSelectedArtistsUseCase: fetchSelectedArtistsUseCase,
            resetSelectedArtistsUseCase: resetSelectedArtistsUseCase
        )
    }
    
    private func makeSearchArtistsUseCase() -> SearchArtistsUseCase {
        SearchArtistsUseCaseImpl(repository: artistRepository)
    }
    
    private func makeSelectArtistUseCase() -> SelectArtistUseCase {
        SelectArtistUseCaseImpl(repository: artistRepository)
    }
    
    private func makeDeselectArtistUseCase() -> DeselectArtistUseCase {
        DeselectArtistUseCaseImpl(repository: artistRepository)
    }
    
    private func makeFetchSelectedArtistsUseCase() -> FetchSelectedArtistsUseCase {
        FetchSelectedArtistsUseCaseImpl(repository: artistRepository)
    }
    
    private func makeResetSelectedArtistsUseCase() -> ResetSelectedArtistsUseCase {
        ResetSelectedArtistsUseCaseImpl(repository: artistRepository)
    }
    
}
