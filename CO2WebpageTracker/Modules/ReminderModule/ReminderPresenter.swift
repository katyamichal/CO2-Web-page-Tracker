//
//  ReminderPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 05.08.2024.
//

import Foundation
protocol IReminderPresenter: AnyObject {
    func viewDidLoad(view: IReminderView)
    func viewIsReady()
}

final class ReminderPresenter {
    private weak var view: IReminderView?
    private weak var coordinator: Coordinator?
    private let dataService: IDataService

    init(coordinator: Coordinator, dataService: IDataService) {
        self.coordinator = coordinator
        self.dataService = dataService
    }
    
    deinit {
        print("ReminderPresenter Deinit")
    }
}

extension ReminderPresenter: IReminderPresenter {
    func viewDidLoad(view: IReminderView) {
        self.view = view
    }
    
    func viewIsReady() {
    
    }
}
