//
//  WebPageListAssembly.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit
enum WebPageListAssembly {
    
    struct Dependencies {
        let service: INetworkService
    }
    
    static func makeModule(dependencies: Dependencies) -> UIViewController {
        let presenter = WebPageListPresenter(networkService: dependencies.service)
        let viewController = WebPageListViewController(presenter: presenter)
        return viewController
    }
}
