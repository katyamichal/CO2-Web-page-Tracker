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
    private let webPageId: UUID?
    
    init(navigationController: UINavigationController, dataService: IDataService, dataDto: WebsiteData? = nil, webPageId: UUID? = nil) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.dataDTO = dataDto
        self.webPageId = webPageId
    }
    
    func start() {
        showModule()
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}

private extension WebPageCoordinator {
    func showModule() {
        let presenter: WebPagePresenter
        if let dataDTO {
        presenter = WebPagePresenter(coordinator: self, dataService: dataService, data: dataDTO)
        } else {
            presenter = WebPagePresenter(coordinator: self, dataService: dataService, id: webPageId)
        }
        let viewController = WebPageViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}


