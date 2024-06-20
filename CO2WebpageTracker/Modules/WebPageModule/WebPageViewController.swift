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
    func updateEnergyWasteTypeCell()
    func showAlert(with type: Constants.AlerMessagesType)
    func showMessage(with message: String)
}

final class WebPageViewController: UIViewController {
    private var webPageView: WebPageView { return self.view as! WebPageView }
    private let presenter: IWebPagePresenter
    
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
    
    func updateEnergyWasteTypeCell() {
        let indexPath = IndexPath(row: 0, section: WebPageSection.energyType.rawValue)
        webPageView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert(with type: Constants.AlerMessagesType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: type.cancelButtonTitle, style: .cancel)
        let resaveAction = UIAlertAction(title: type.actionButtonTitle, style: .default) { _ in
            self.presenter.saveWebPage()
        }
        alert.addAction(cancelAction)
        alert.addAction(resaveAction)
        self.present(alert, animated: true)
    }
    
    func showMessage(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
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
        let image = UIImage(systemName: Constants.UIElementSystemNames.actionMenu, withConfiguration: configuration)
        let rightBarItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        rightBarItem.tintColor = .white
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: Constants.UIElementTitle.share, image: UIImage(systemName: Constants.UIElementSystemNames.share), handler: shareWebPage),
            UIAction(title: Constants.UIElementTitle.save, image: UIImage(systemName: Constants.UIElementSystemNames.save), handler: save),
            UIAction(title: Constants.UIElementTitle.delete, image: UIImage(systemName: Constants.UIElementSystemNames.delete), handler: selectionHandler)
        ])
        rightBarItem.menu = barButtonMenu
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func save(action: UIAction) {
        presenter.prepareToSave()
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
