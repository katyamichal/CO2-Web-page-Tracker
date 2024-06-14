//
//  WebPageListPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

final class WebPageListPresenter {
    private weak var view: IWebPageListView?
    private let networkService: INetworkService
    private var viewData: [WebPageListViewData] = []
    private var progress: [UUID: Float] = [:]


    init(networkService: INetworkService) {
        self.networkService = networkService
    }
}

extension WebPageListPresenter: IWebPageListPresenter {
    func viewDidLoaded(view: IWebPageListView) {
        self.view = view
    }
    
    func loadData(with keyword: String) {
        networkService.performRequest(with: keyword, id: UUID())
    }
    
    func updateViewData(with id: UUID) {
        
    }
    
    func getRowCountInSection() -> Int {
        viewData.count
    }
    
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell {
        cell(for: tableView, at: index)
    }
    
    func updateRow(at index: Int) {
        
    }
    
    func heightForRow(at index: Int) -> CGFloat {
        3.0
    }
    
    func permitDeleting(at index: IndexPath) -> Bool {
        true
    }
    
    func deleteRow(at index: IndexPath) {
    
    }
}

private extension WebPageListPresenter {
    enum PauseLoadingImages {
        static let paused = UIImage(systemName: Constants.UIElementNameStrings.pausedImage)
        static let active = UIImage(systemName: Constants.UIElementNameStrings.activeImage)
    }
    
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WebPageListTableViewCell.reuseIdentifier, for: indexPath) as? WebPageListTableViewCell else {
            return UITableViewCell()
        }
        let data = viewData[indexPath.row]
        cell.currentState = data.loadingStatus
        return cell
    }
    
    func checkForEmptyTextField(with keyword: String) -> Bool {
        let searchKeyword = keyword.trimmingCharacters(in: .whitespaces)
        guard !searchKeyword.isEmpty else {
            view?.showAlert(with: .emptyTextField)
            return false
        }
        return true
    }
    
    func setupComplitionHandlers() {
        configureServiceCompletionHandler()
        configureDownloadingProssesHandler()
    }
    
    func configureServiceCompletionHandler() {
        networkService.backgroundCompletionHandler = { [weak self] (webpageId, responseData, error) in
            guard let self = self else { return }
            
            guard let index = self.viewData.firstIndex(where: { $0.webpageId == webpageId }) else { return }
            if let responseData {
                self.viewData[index].loadingStatus = .completed(url: responseData.url)
            } else {
                let failedMessage = self.configureErrorResponse(with: error!)
                self.viewData[index].loadingStatus = .failed(message: failedMessage)
            }
            DispatchQueue.main.async {
                self.view?.updateView()
            }
        }
    }
    
    
    
    func configureDownloadingProssesHandler() {
        networkService.progressHandler = { [weak self] (webpageId, progressValue) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let index = self.viewData.firstIndex(where: { $0.webpageId == webpageId }) {
                    self.viewData[index].loadingStatus = .loading(progress: Float(progressValue), image: PauseLoadingImages.active)
                    self.progress[webpageId] = Float(progressValue)
                }
                self.view?.updateView()
            }
        }
    }
    
//    func setLoading(at index: Int, with status: LoadingStatus, with data: Any?) {
//        viewData[index].loadingStatus = .completed(image: data as UI)
//    }
    
    func configureErrorResponse(with type: APIError) -> String {
        switch type {
        case .noInternetConnection:
            return Constants.CellLoadingMessage.noInternetConnection
        case .invalidURL, .decodingError, .invalidResponse:
            return Constants.CellLoadingMessage.failFetchData
        case .urlSessionError:
            return Constants.CellLoadingMessage.urlSessionError
        case .serverError:
            return Constants.CellLoadingMessage.serverError
        }
    }
    
}
