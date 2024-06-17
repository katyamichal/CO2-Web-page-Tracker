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
    let navigationController: UINavigationController
    
    let dataService: IDataService
   // let dataDTO: WebsiteData
    
    init(navigationController: UINavigationController, dataService: IDataService) {
        self.navigationController = navigationController
//        self.factory = factory
        self.dataService = dataService
       // self.dataDTO = dataDTO
        //self.dataService = networkService
    }
    
    func start() {
        showModule()
    }
}

private extension WebPageCoordinator {
    func showModule() {
        let presenter = WebPagePresenter(coordinator: self, dataService: dataService, id: nil) 
        let viewController = WebPageViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}


