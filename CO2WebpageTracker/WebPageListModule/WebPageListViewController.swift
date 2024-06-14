//
//  WebPageListViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 11.06.2024.
//

import UIKit
protocol IWebPageListView: AnyObject {
    func updateView()
    func prepareForRequest(with id: UUID)
    func deleteRow(at indexPath: IndexPath)
}

final class WebPageListViewController: UIViewController {
    
    private var webPageListView: WebPageListView { return self.view as! WebPageListView }
    private let presenter: IWebPageListPresenter
    
    // MARK: - Inits
    
    init(presenter: IWebPageListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cycle

    override func loadView() {
        view = WebPageListView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded(view: self)
        setupTableViewDelegates()
    }
}

extension WebPageListViewController: IWebPageListView {
    func updateView() {
        
    }
    
    func prepareForRequest(with id: UUID) {
        
    }
    
    func deleteRow(at indexPath: IndexPath) {
        
    }
}

extension WebPageListViewController: UITableViewDelegate {}

extension WebPageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getRowCountInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.rowForCell(tableView: tableView, at: indexPath)
    }
}



private extension WebPageListViewController {
    func setupTableViewDelegates() {
        webPageListView.tableView.delegate = self
        webPageListView.tableView.dataSource = self
    }
}
