//
//  WebPageCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

final class WebPageCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let dataService: IDataService
    private let dataDTO: WebsiteData?
    private let webPageURL: String?
    
    init(navigationController: UINavigationController, dataService: IDataService, dataDto: WebsiteData? = nil, webPageURL: String? = nil) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.dataDTO = dataDto
        self.webPageURL = webPageURL
    }
    
    func start() {
        showModule()
    }
    
    func backToDetail() {
        navigationController.popToRootViewController(animated: true)

    }
}

private extension WebPageCoordinator {
    func showModule() {
        let presenter: WebPagePresenter
        if let dataDTO {
        presenter = WebPagePresenter(coordinator: self, dataService: dataService, data: dataDTO)
        } else {
            presenter = WebPagePresenter(coordinator: self, dataService: dataService, webPageURL: webPageURL)
        }
        let viewController = WebPageViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}


