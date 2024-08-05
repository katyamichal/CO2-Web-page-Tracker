//
//  ReminderViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 05.08.2024.
//

import UIKit

protocol IReminderView: AnyObject {

}

final class ReminderViewController: UIViewController {
    private var reminderView: ReminderView { return self.view as!  ReminderView }
    private let presenter: IReminderPresenter
    
    // MARK: - Init
    
    init(presenter: IReminderPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ReminderViewController Deinit")
    }
    
    // MARK: - Cycle
    override func loadView() {
        view = ReminderView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        presenter.viewIsReady()
    }
}

extension ReminderViewController: IReminderView {
    
}
