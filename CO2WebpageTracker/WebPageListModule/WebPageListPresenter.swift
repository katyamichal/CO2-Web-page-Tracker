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
    private var viewData: [WebPageListViewData] = []


    init(dataService: IDataService) {
        self.dataService = dataService
    }
}

extension WebPageListPresenter: IWebPageListPresenter {
    func viewDidLoaded(view: IWebPageListView) {
        self.view = view
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

private extension WebPageListPresenter {
 
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebPageListCollectionViewCell.reuseIdentifier, for: indexPath) as? WebPageListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let data = viewData[indexPath.row]
   
        return cell
    }
}
