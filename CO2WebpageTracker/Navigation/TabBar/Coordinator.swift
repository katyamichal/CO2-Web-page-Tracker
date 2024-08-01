//
//  Coordinator.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 15.06.2024.
//

import Foundation

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func finish()
}

protocol CoordinatorDetail: AnyObject {
    func showDetail(with url: String)
}

extension Coordinator {
    func finish() {
        _ = parentCoordinator?.childCoordinators.popLast()
        parentCoordinator = nil
    }
}
