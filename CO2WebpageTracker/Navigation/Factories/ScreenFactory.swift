//
//  AppFactory.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 15.06.2024.
//

import Foundation
import UIKit

struct ScreenFactory {
    
    let appDIContainer: AppDIContainer?
    
    init(appDIContainer: AppDIContainer?) {
        self.appDIContainer = appDIContainer
    }
//
//    struct Dependencies {
//        let coordinator: Coordinator
//        let networkService: INetworkService
//        let dataService: IDataService
//    }
//    
    func makeSearchScene() -> UIViewController {
        guard let network = appDIContainer?.networkService else { return UIViewController() }
        //let coordinator = coordinator
        let presenter = SearchWebPageViewPresenter(coordinator: coordinator, networkService: network)
        
        let viewController = SearchWebPageViewController(presenter: presenter)
        return viewController
    }
    
    func makeWebPageListScene() -> UIViewController {
        return UIViewController()
    }
    
    func makeWebPageScene() -> UIViewController {
        return UIViewController()
    }
}

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
