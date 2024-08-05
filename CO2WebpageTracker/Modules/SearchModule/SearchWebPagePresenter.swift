//
//  SearchWebPageViewPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class SearchWebPagePresenter {
    
    private let networkService: INetworkService
    private weak var coordinator: Coordinator?
    private weak var view: ISearchWebPageView?
    private var viewData = SearchViewData(searchStatus: .search)
    
    // MARK: - Init
    
    init(coordinator: Coordinator, networkService: INetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
        configureServiceCompletionHandler()
    }
}

extension SearchWebPagePresenter: ISearchWebPagePresenter {
    func viewDidLoaded(view: ISearchWebPageView) {
        self.view = view
    }
    
    func loadData(with url: String) {
        networkService.performRequest(with: url)
        updateSearchStatus(with: .load(status: .loading(message: Constants.SearchLoadingMessage.loading)))
        updateView()
    }
   
    // MARK: - Loading Handeling
    
    func prepareToLoad(with url: String) -> Bool {
        checkForEmptyTextField(with: url) ? true : false
    }
    
    func tryAgainButtonPressed() {
        updateSearchStatus(with: .search)
        updateView()
    }
    
    func cancelLoading() {
        networkService.cancelLoading()
        updateSearchStatus(with: .search)
        updateView()
    }
    
    func switchPauseResumeLoading() {
        let currentStatus = viewData.searchStatus
        
        switch currentStatus {
        case .load(let loadingStatus):
            
            switch loadingStatus {
            case .paused:
                updateSearchStatus(with: .load(status: .loading(message: Constants.SearchLoadingMessage.loading)))
                networkService.resumeLoading()
            case .loading:
                updateSearchStatus(with: .load(status: .paused))
                networkService.pauseLoading()
            case .completed, .failed, .nonActive:
                break
            }
        case .search:
            break
        }
        updateView()
    }
}

private extension SearchWebPagePresenter {
    // MARK: - View and Data Updatig

    func updateSearchStatus(with status: SearchStatus) {
        viewData.searchStatus = status
    }
    
    func updateView() {
        view?.updateView(with: viewData.searchStatus)
    }
   
    // MARK: - Text Field Configuration

    func checkForEmptyTextField(with keyword: String) -> Bool {
        let searchKeyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !searchKeyword.isEmpty else {
            view?.showAlert(with: .emptyTextField)
            return false
        }
        return true
    }
    
    // MARK: - Networking Complition

    func configureServiceCompletionHandler() {
        networkService.backgroundCompletionHandler = { [weak self] (responseData, error) in
            guard let self else { return }
            if let responseData {
                self.viewData.searchStatus = .search
                DispatchQueue.main.async {
                    (self.coordinator as? SearchCoordinator)?.showDetail(with: responseData)
                }
            } else {
                let failedMessage = self.configureErrorResponse(with: error!)
                self.updateSearchStatus(with: .load(status: .failed(message: failedMessage)))
            }
            DispatchQueue.main.async {
                self.view?.updateView(with: self.viewData.searchStatus)
            }
        }
    }
    
    func configureErrorResponse(with type: APIError) -> String {
        switch type {
        case .noInternetConnection:
            return Constants.SearchLoadingMessage.noInternetConnection
        case .invalidURL, .decodingError, .invalidResponse:
            return Constants.SearchLoadingMessage.failFetchData
        case .urlSessionError:
            return Constants.SearchLoadingMessage.urlSessionError
        case .serverError:
            return Constants.SearchLoadingMessage.serverError
        }
    }
}
