//
//  SearchWebPageViewPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

protocol ISearchWebPagePresenter: AnyObject {
    func viewDidLoaded(view: ISearchWebPageView)
    func prepareToLoad(with url: String) -> Bool
    func loadData(with url: String)
    func updateViewData()
    func tryAgainButtonPressed()
    func changeLoadingStatus()
}

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
    func changeLoadingStatus() {
        let currentStatus = viewData.searchStatus
        switch currentStatus {
        case .load(let loadingStatus):
            switch loadingStatus {
            case .paused:
                viewData.searchStatus = .load(status: .loading(message: "You have stopped loading"))
                networkService.resumeLoading()
            case .loading:
                viewData.searchStatus = .load(status: .paused)
                networkService.pauseLoading()
            case .completed, .failed, .nonActive:
                break
            }
        case .search:
            break
        }
        view?.updateView(with: viewData.searchStatus)
    }
    
    func prepareToLoad(with url: String) -> Bool {
        guard checkForEmptyTextField(with: url) else {
            return false
        }
        return true
    }
    
    func tryAgainButtonPressed() {
        viewData.searchStatus = .search
        view?.updateView(with: viewData.searchStatus)
    }

    func viewDidLoaded(view: ISearchWebPageView) {
        self.view = view
    }
    
    func loadData(with url: String) {
        networkService.performRequest(with: url)
        updateViewData()
    }
    
    func updateViewData()  {
        viewData.searchStatus = .load(status: .loading(message: Constants.SearchLoadingMessage.waitForLoad))
        view?.updateView(with: viewData.searchStatus)
    }
}

private extension SearchWebPagePresenter {
    enum PauseLoadingImages {
        static let paused = UIImage(systemName: Constants.UIElementSystemNames.pausedImage)
        static let active = UIImage(systemName: Constants.UIElementSystemNames.activeImage)
    }
    
    func checkForEmptyTextField(with keyword: String) -> Bool {
        let searchKeyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !searchKeyword.isEmpty else {
            view?.showAlert(with: .emptyTextField)
            return false
        }
        return true
    }
    
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
                self.viewData.searchStatus = .load(status: .failed(message: failedMessage))
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
