//
//  WebPageListPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

final class WebPageListPresenter {
    private weak var view: IWebPageListView?
    private let dataService: IDataService
    private weak var coordinator: Coordinator?
    private var viewData: [WebPageListViewData] = []


    init(coordinator: Coordinator, dataService: IDataService) {
        self.coordinator = coordinator
        self.dataService = dataService
    }
}

extension WebPageListPresenter: IWebPageListPresenter {
    func showDetailView(at index: Int) {
        let id = viewData[index].id
        (coordinator as? WebPageListCoordinator)?.showWebPageDetail(with: id)
    }
    
    func viewDidLoaded(view: IWebPageListView) {
        self.view = view
        self.view?.setupNavigationBar(with: "Web Pages")
        dataService.addFetchDelegate(self)
        getData()
    }
    
    func getRowCountInSection() -> Int {
        viewData.count
    }
    
    func rowForCell(collectionView: UICollectionView, at index: IndexPath) -> UICollectionViewCell {
        cell(for: collectionView, at: index)
    }
    
    func updateRow(at index: Int) {
        
    }
    
    func permitDeleting(at index: IndexPath) -> Bool {
        true
    }
    
    func deleteRow(at index: IndexPath) {
        
    }
}


extension WebPageListPresenter: IFetchResultControllerDelegate {
    func insertObject(at index: IndexPath, with object: WebPageListViewData) {
        viewData.insert(object, at: index.row)
        view?.insertRow(at: index)
    }
    
    func objectDidChange(at index: IndexPath, with object: WebPageListViewData) {
        viewData[index.row] = object
        view?.update()
    }
        
    func deleteRow(at index: Int) {
        //
    }
}

private extension WebPageListPresenter {
    func getData() {
        dataService.fetchWepPages { [weak self] data in
            self?.dataService.performFetch()
            self?.viewData = data
            if viewData.count == 0 {
                viewData.append(contentsOf: generateSampleWebPageData())
            }
            self?.view?.update()
        }
    }
    
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPageListCollectionViewCell.reuseIdentifier, for: indexPath) as? WebPageListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = viewData[indexPath.row]

        cell.updateLabels(url: data.url, rating: data.rating)
        return cell
    }
    
    func generateSampleWebPageData() -> [WebPageListViewData] {
        return [
            WebPageListViewData(url: "https://example.com", date: Date(), rating: "A"),
        ]
    }
}
