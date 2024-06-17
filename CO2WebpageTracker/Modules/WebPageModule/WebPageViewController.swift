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
        let config2 = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        let image2 = UIImage(systemName: "square.and.arrow.up", withConfiguration: config2)
        let rightBarButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(shareProduct))
        navigationItem.rightBarButtonItem = rightBarButton
 
//        
//        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
//        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: configuration)
//        let rightBarItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
//        rightBarItem.tintColor = Colours.Button.addButtonColour
//        
//        
//        
//        let barButtonMenu = UIMenu(title: "", children: [
//            
////            UIAction(title: NSLocalizedString("Show only pinned", comment: ""), image: UIImage(systemName: "pin"), handler: menuHandler),
////
//            UIAction(title: NSLocalizedString("", comment: ""), image: UIImage(systemName: ""), handler: selectionHandler)
//        ])
//        rightBarItem.menu = barButtonMenu
//        navigationItem.rightBarButtonItem = rightBarItem
//        
//        self.navigationController?.isToolbarHidden = false
//        self.navigationController?.toolbar.tintColor = Colours.Button.addButtonColour
//        self.navigationController?.toolbar.backgroundColor = .clear
//        
//        var items = [UIBarButtonItem]()
//        items.append(
//            UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        )
//        items.append(
//            UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tappedToolBarItem))
//        )
//        toolbarItems = items
    }
    
    @objc
    func tappedToolBarItem() {
        
    }
    
    @objc
    func shareProduct() {
        // 
        let url = URL(string: "https://www.websitecarbon.com/website/instagram-com/")!
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.title = "Instagram"
        activityVC.excludedActivityTypes = [.airDrop]
        
        self.present(activityVC, animated: true)
    }
    
    
    func selectionHandler(action: UIAction) {
        //        notesView.collectionView.performBatchUpdates {
        //            notesView.collectionView.isEditing = true
        //            notesViewModel.notes.remove(at: 0)
        //            notesView.collectionView.deleteItems(at: [IndexPath(row: 0, section: 0)])
        //           // notesViewModel.deleteNote(notes: )
        //            notesView.collectionView.endEditing(true)
        //        }
        
    }
}
