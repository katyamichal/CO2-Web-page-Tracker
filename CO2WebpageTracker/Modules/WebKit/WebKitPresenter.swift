//
//  WebKitPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import Foundation

protocol IWebKitPresenter: AnyObject {
    var urlRequest: URLRequest? { get }
    func viewDidLoaded(view: IWebKitView)
    func viewIsReady()
    func viewIsLoading()
    func viewIsLoaded()
    func viewIsLoaded(with error: Error)
    func doneButtonDidTapped()
}

final class WebKitPresenter {
    private weak var coordinator: Coordinator?
    private weak var view: IWebKitView?
    private let viewData: WebKitViewData
    
    init(coordinator: Coordinator, url: String) {
        self.coordinator = coordinator
        viewData = WebKitViewData(url: url)
    }
}

// MARK: - Protocol

extension WebKitPresenter: IWebKitPresenter {
    func viewIsLoaded(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showError(message: .errorToLoadWebKit)
    }
    
    func viewIsLoading() {
        view?.showLoadingIndicator()
    }
    
    func viewDidLoaded(view: IWebKitView) {
        self.view = view
    }
    
    func viewIsReady() {
        view?.makeRequest()
    }
    
    var urlRequest: URLRequest? {
        URLConstructor.createURLRequest(with: viewData.url)
    }
    
    func viewIsLoaded() {
        view?.hideLoadingIndicator()
    }
    
    func doneButtonDidTapped() {
        (coordinator as? WebKitCoordinator)?.goBack()
    }
}
