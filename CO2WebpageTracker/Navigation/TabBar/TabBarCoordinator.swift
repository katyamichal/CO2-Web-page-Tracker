//
//  TabBarCoordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

enum TabBarImageView: String, CaseIterable {
    case search = "magnifyingglass"
    case list = "list.bullet.clipboard"
}

final class TabBarCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    private var window: UIWindow
    private let networkService: INetworkService
    private let dataService: IDataService
    private var tabBarController: TabBarController?

    // MARK: - Init

    init(window: UIWindow, networkService: INetworkService, dataService: IDataService) {
        self.window = window
        self.networkService = networkService
        self.dataService = dataService
    }
    
    func start() {
        showTabBarFlow()
    }
}

private extension TabBarCoordinator {
    func showTabBarFlow() {
        let searchImage = UIImage(systemName: TabBarImageView.search.rawValue)
        let searchNavigationController = UINavigationController()
        searchNavigationController.tabBarItem = UITabBarItem(title: "Search", image: searchImage, selectedImage: searchImage)
        let searchCoordinator = SearchCoordinator(navigationController: searchNavigationController, networkService: networkService, dataService: dataService)
        searchCoordinator.parentCoordinator = self
        searchCoordinator.start()
        
        let listImage = UIImage(systemName: TabBarImageView.list.rawValue)
        let webPageListNavigationController = UINavigationController()
        webPageListNavigationController.tabBarItem = UITabBarItem(title: "Web Pages", image: listImage, selectedImage: listImage)
        let webPageListCoordinator = WebPageListCoordinator(navigationController: webPageListNavigationController, dataService: dataService)
        webPageListCoordinator.parentCoordinator = self
        webPageListCoordinator.start()
        
        childCoordinators.append(searchCoordinator)
        childCoordinators.append(webPageListCoordinator)
        
        let tabBarControllers = [searchNavigationController, webPageListNavigationController]
        tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        
//        let appState = AppStateService.shared.retrieve()
//        let curTab = appState?.currentTab.rawValue ?? 0
//        tabBarController?.selectedIndex = curTab
//        if let appState, appState.isEditingMode == .edinitig, let url = appState.url {
//            (childCoordinators[curTab] as? CoordinatorDetail)?.showDetail(with: url)
//        }
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
