//
//  AppFactory.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 15.06.2024.
//

import Foundation
import UIKit

//struct ScreenFactory {
//    
//    struct Dependencies {
//        let networkService: INetworkService
//        let dataService: IDataService
//    }
//    
//    func makeSearchScene(navigationController: UINavigationController, dependencies: Dependencies) -> UIViewController {
//        let network = dependencies.networkService
//        let coordinator = SearchCoordinator(navigationController: navigationController)
//        let presenter = SearchWebPageViewPresenter(coordinator: coordinator, networkService: network)
//        let viewController = SearchWebPageViewController(presenter: presenter)
//        return viewController
//    }
//    
//    func makeWebPageListScene(navigationController: UINavigationController, dependencies: Dependencies) -> UIViewController {
//        let dataServiece = dependencies.dataService
//        let coordinator = WebPageListCoordinator(navigationController: navigationController, factory: , dataService: <#T##IDataService#>, networkService: <#T##INetworkService#>)
//        let presenter = WebPageListPresenter(dataService: dataServiece)
//        let viewController = WebPageListViewController(presenter: presenter)
//        return UIViewController()
//    }
//    
//    func makeWebPageScene() -> UIViewController {
//        return UIViewController()
//    }
//}

//
//let someService: SomeService
//   let anotherService: AnotherService
//
//   init(someService: SomeService, anotherService: AnotherService) {
//       self.someService = someService
//       self.anotherService = anotherService
//   }
//
//   func makeFirstViewController() -> FirstViewController {
//       let viewModel = FirstViewModel(service: someService)
//       let viewController = FirstViewController(viewModel: viewModel)
//       return viewController
//   }
//
//   func makeSecondViewController() -> SecondViewController {
//       let viewModel = SecondViewModel(service: anotherService)
//       let viewController = SecondViewController(viewModel: viewModel)
//       return viewController
//   }
