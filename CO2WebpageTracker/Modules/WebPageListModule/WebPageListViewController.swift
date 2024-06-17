//
//  WebPageListViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 11.06.2024.
//

import UIKit
protocol IWebPageListView: AnyObject {
//    func beginUpdate()
//    func endUpdate()
    func setupNavigationBar(with title: String)
    func insertRow(at index: IndexPath)
    func update()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension WebPageListViewController: IWebPageListView {
    func setupNavigationBar(with title: String) {
        navigationItem.title = title
    }
    
    func insertRow(at index: IndexPath) {
        webPageListView.collectionView.insertItems(at: [index])
    }
    

    
    func update() {
        webPageListView.collectionView.reloadData()
    }
    
    func prepareForRequest(with id: UUID) {
        
    }
    
    func deleteRow(at indexPath: IndexPath) {
        
    }
}

extension WebPageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetailView(at: indexPath.row)
    }
}

extension WebPageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getRowCountInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        presenter.rowForCell(collectionView: collectionView, at:indexPath)
    }
}



private extension WebPageListViewController {
    func setupTableViewDelegates() {
        webPageListView.collectionView.delegate = self
        webPageListView.collectionView.dataSource = self
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Colours.WebPageColours.yellow
    }
}
