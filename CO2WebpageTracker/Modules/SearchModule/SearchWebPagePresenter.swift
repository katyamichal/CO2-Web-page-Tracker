//
//  SearchWebPageViewPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

protocol ISearchWebPagePresenter: AnyObject {
    func viewDidLoaded(view: ISearchWebPageView)
    func loadData(with url: String)
    func updateViewData()
    func tryAgainButtonPressed()
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
    func tryAgainButtonPressed() {
        viewData.searchStatus = .search
        view?.updateView(with: viewData.searchStatus)
    }

    func viewDidLoaded(view: ISearchWebPageView) {
        self.view = view
    }
    
    func loadData(with url: String) {
        guard checkForEmptyTextField(with: url) else { return }
        networkService.performRequest(with: url)
        updateViewData()
    }
    
    func updateViewData()  {
        viewData.searchStatus = .load(status: .loading(message: Constants.SearchLoadingMessage.waitForLoad, image: PauseLoadingImages.paused))
        view?.updateView(with: viewData.searchStatus)
    }
}

private extension SearchWebPagePresenter {
    enum PauseLoadingImages {
        static let paused = UIImage(systemName: Constants.UIElementNameStrings.pausedImage)
        static let active = UIImage(systemName: Constants.UIElementNameStrings.activeImage)
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
    
 ///   www.websitecarbon.com
    
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
