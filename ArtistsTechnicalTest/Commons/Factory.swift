//
//  Factory.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 20/10/2024.
//

import UIKit

// MARK: - Factory

/// A protocol defining the requirements for a factory that creates view controllers.
protocol Factory {
    
    /// Creates and returns a new instance of the SearchArtistsViewController.
    /// - Returns: An instance of UIViewController.
    func makeSearchArtistsViewController() -> UIViewController
}

// MARK: - FactoryImpl

/// A final implementation of the `Factory` protocol.
/// This class is responsible for creating various components required by the application,
/// including view controllers and use cases.
final class FactoryImpl: Factory {
    
    // MARK: - Private properties
    
    /// The service used to handle network requests.
    private let service: Service = ServiceImpl()
    
    /// The mapper responsible for converting artist data between different layers.
    private let artistMapper: ArtistMapper = ArtistMapper()
    
    /// The error mapper used to translate service-specific errors to application-level errors.
    private let errorMapper: ErrorMapper = ErrorMapper()
    
    /// The data store used to manage artist data.
    private let dataStore: ArtistDataStore = ArtistDataStoreImpl()
    
    /// The mapper for converting domain models to UI models.
    private let artistUIMapper: ArtistUIMapper = ArtistUIMapper()
    
    /// The repository used to manage artist-related data and operations.
    private lazy var artistRepository: ArtistRepository = ArtistRepositoryImpl(
        service: service,
        artistMapper: artistMapper,
        errorMapper: errorMapper,
        dataStore: dataStore
    )
    
    // MARK: - Public method
    
    /// Creates and returns a new instance of the `SearchArtistsViewController`.
    /// - Returns: An instance of `UIViewController` representing the search artists interface.
    func makeSearchArtistsViewController() -> UIViewController {
        
        // Create the view model for the view controller
        let viewModel = makeSearchArtistsViewModel()
        
        // Return the view controller
        return SearchArtistsViewController(viewModel: viewModel)
    }
    
    // MARK: - Private methods
    
    /// Creates and returns a new instance of the `SearchArtistsViewModel`.
    /// - Returns: An instance of `SearchArtistsViewModel` for managing the search artists logic.
    private func makeSearchArtistsViewModel() -> SearchArtistsViewModel {
        
        // Create the use case for searching artists
        let searchArtistsUseCase = makeSearchArtistsUseCaseQueryValidator()
        
        // Create the use case for selecting an artist
        let selectArtistUseCase = makeSelectArtistUseCase()
        
        // Create the use case for deselecting an artist
        let deselectArtistUseCase = makeDeselectArtistUseCase()
        
        // Create the use case for fetching selected artists
        let fetchSelectedArtistsUseCase = makeFetchSelectedArtistsUseCase()
        
        // Create the use case for resetting selected artists
        let resetSelectedArtistsUseCase = makeResetSelectedArtistsUseCase()
        
        
        // Return the fully constructed view model
        return SearchArtistsViewModelImpl(
            searchArtistsUseCase: searchArtistsUseCase,
            mapper: artistUIMapper,
            selectArtistUseCase: selectArtistUseCase,
            deselectArtistUseCase: deselectArtistUseCase,
            fetchSelectedArtistsUseCase: fetchSelectedArtistsUseCase,
            resetSelectedArtistsUseCase: resetSelectedArtistsUseCase
        )
    }
    
    /// Creates and returns a new instance of the `SearchArtistsUseCase` with query validation.
    /// - Returns: An instance of `SearchArtistsUseCase & QueryValidator`.
    private func makeSearchArtistsUseCaseQueryValidator() -> SearchArtistsUseCase & QueryValidator {
        
        // Return the use case implementation
        SearchArtistsUseCaseImpl(repository: artistRepository)
    }
    
    /// Creates and returns a new instance of the `SelectArtistUseCase`.
    /// - Returns: An instance of `SelectArtistUseCase`.
    private func makeSelectArtistUseCase() -> SelectArtistUseCase {
        
        // Return the use case implementation
        SelectArtistUseCaseImpl(repository: artistRepository)
    }
    
    /// Creates and returns a new instance of the `DeselectArtistUseCase`.
    /// - Returns: An instance of `DeselectArtistUseCase`.
    private func makeDeselectArtistUseCase() -> DeselectArtistUseCase {
        
        // Return the use case implementation
        DeselectArtistUseCaseImpl(repository: artistRepository)
    }
    
    /// Creates and returns a new instance of the `FetchSelectedArtistsUseCase`.
    /// - Returns: An instance of `FetchSelectedArtistsUseCase`.
    private func makeFetchSelectedArtistsUseCase() -> FetchSelectedArtistsUseCase {
        
        // Return the use case implementation
        FetchSelectedArtistsUseCaseImpl(repository: artistRepository)
    }
    
    /// Creates and returns a new instance of the `ResetSelectedArtistsUseCase`.
    /// - Returns: An instance of `ResetSelectedArtistsUseCase`.
    private func makeResetSelectedArtistsUseCase() -> ResetSelectedArtistsUseCase {
        
        // Return the use case implementation
        ResetSelectedArtistsUseCaseImpl(repository: artistRepository)
    }
    
}
