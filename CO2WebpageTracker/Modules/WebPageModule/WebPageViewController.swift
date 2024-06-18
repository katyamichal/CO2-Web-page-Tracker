//
//  WebPageViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit
protocol IWebPageView: AnyObject {
    func update()
    func setupNavigationTitle(with title: String)
    
}

final class WebPageViewController: UIViewController {
    private var webPageView: WebPageView { return self.view as! WebPageView }
    private let presenter: IWebPagePresenter
    private var barButtonMenu = UIMenu()
    
    // MARK: - Inits
    
    init(presenter: IWebPagePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cycle

    override func loadView() {
        view = WebPageView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded(view: self)
        setupTableViewDelegates()
        setupNavigationBar()
    }
}

extension WebPageViewController: IWebPageView {
    
    func update() {
        webPageView.tableView.reloadData()
    }
    
    func setupNavigationTitle(with title: String) {
        navigationItem.title = title
    }
}

extension WebPageViewController: UITableViewDelegate {}

extension WebPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getRowCountInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.rowForCell(tableView: tableView, at: indexPath)
    }
}

private extension WebPageViewController {
    func setupTableViewDelegates() {
        webPageView.tableView.dataSource = self
        webPageView.tableView.delegate = self
    }
    
    
    func setupNavigationBar() {
//        let config2 = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
//        let image2 = UIImage(systemName: "square.and.arrow.up", withConfiguration: config2)
//        let rightBarButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(shareProduct))
//        navigationItem.rightBarButtonItem = rightBarButton
//
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: configuration)
        let rightBarItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        rightBarItem.tintColor = Colours.WebPageColours.yellowish
        
        barButtonMenu = UIMenu(title: "Menu", children: [
            UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), handler: shareWebPage),
            UIAction(title: "Save", image: UIImage(systemName: "tray.full"), handler: save),
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), handler: selectionHandler)
        ])
        rightBarItem.menu = barButtonMenu
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func save(action: UIAction) {
        presenter.saveButtonDidPressed()
    }
    
    func selectionHandler(action: UIAction) {
        presenter.deleteButtonDidPressed()
    }
    
    func shareWebPage(action: UIAction) {
        //
        let url = URL(string: "https://www.websitecarbon.com/website/instagram.com/")!
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.title = "Instagram"
        activityVC.excludedActivityTypes = [.airDrop]
        self.present(activityVC, animated: true)
    }
}
