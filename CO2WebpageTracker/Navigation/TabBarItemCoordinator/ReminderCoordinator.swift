//
//  ReminderCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 05.08.2024.
//

import UIKit

final class ReminderCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let dataService: IDataService
    private let webPageURL: String
    
    init(navigationController: UINavigationController, dataService: IDataService, webPageURL: String) {
        self.navigationController = navigationController
        self.dataService = dataService
        self.webPageURL = webPageURL
    }
    
    func start() {
        showModule()
    }
}

private extension ReminderCoordinator {
    func showModule() {
        let presenter = ReminderPresenter(coordinator: self, dataService: dataService)
        let viewController = ReminderViewController(presenter: presenter)
        navigationController.pushViewController(viewController, animated: true)
    }
}
