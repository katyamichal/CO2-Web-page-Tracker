//
//  WebPageListViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 11.06.2024.
//

import UIKit
protocol IWebPageListView: AnyObject {
    func update()
    func setupNavigationBar(with title: String)
    func beginUpdate()
    func endUpdate()
    func insertRow(at index: IndexPath)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension WebPageListViewController: IWebPageListView {
    func update() {
        webPageListView.tableView.reloadData()
    }
    
    func setupNavigationBar(with title: String) {
        navigationItem.title = title
    }
    
    func beginUpdate() {
        webPageListView.tableView.beginUpdates()
    }
    
    func endUpdate() {
        webPageListView.tableView.endUpdates()
    }
    
    func insertRow(at index: IndexPath) {
        webPageListView.tableView.insertRows(at: [index], with: .fade)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        webPageListView.tableView.beginUpdates()
        webPageListView.tableView.deleteRows(at: [indexPath], with: .fade)
        webPageListView.tableView.endUpdates()
    }
}

extension WebPageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showDetailView(at: indexPath.row)
    }
}

extension WebPageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getRowCountInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.rowForCell(tableView: tableView, at:indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let deleteAction = createDeleteAction(tableView, at: indexPath) else { return nil }
        let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
        swipe.performsFirstActionWithFullSwipe = false
        return swipe
    }
}



private extension WebPageListViewController {
    func setupTableViewDelegates() {
        webPageListView.tableView.delegate = self
        webPageListView.tableView.dataSource = self
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
    }
    
    func createDeleteAction(_ tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.deleteAction(tableView, at: indexPath)
        }
        deleteAction.image = UIImage(systemName: Constants.UIElementSystemNames.deleteActionImage)
        deleteAction.backgroundColor = Colours.WebPageColours.red
        return deleteAction
    }
    
    func deleteAction(_ tableView: UITableView, at indexPath: IndexPath) {
        presenter.actionDidSwipeToDelete(at: indexPath.row)
    }
}
