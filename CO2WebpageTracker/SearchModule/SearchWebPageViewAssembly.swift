//
//  SearchWebPageViewAssembly.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit
enum SearchWebPageViewAssembly {
    
    struct Dependencies {
        let service: INetworkService
    }
    
    static func makeModule(dependencies: Dependencies) -> UIViewController {
        let presenter = SearchWebPageViewPresenter(networkService: dependencies.service)
        let viewController = SearchWebPageViewController(presenter: presenter)
        return viewController
    }
}

