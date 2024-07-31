//
//  WebKitPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import Foundation
import WebKit

protocol IWebKitPresenter: AnyObject {
    var urlRequest: URLRequest? { get }
    func viewDidLoaded(view: IWebKitView)
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

extension WebKitPresenter: IWebKitPresenter {
    func viewDidLoaded(view: IWebKitView) {
        self.view = view
        self.view?.makeRequest()
    }
    
    var urlRequest: URLRequest? {
        
        URLConstructor.createURLRequest(with: viewData.url)
    }
    
    func doneButtonDidTapped() {
        (coordinator as? WebKitCoordinator)?.goBack()
    }
}
