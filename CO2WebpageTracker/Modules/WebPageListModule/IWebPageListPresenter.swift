//
//  IWebPageListPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit
typealias IWebPageListPresenter = IWebPageListViewLifeCycle & IWebPageListLoading & IWebPageListCollectionViewHandler

protocol IWebPageListViewLifeCycle: AnyObject {
    func viewDidLoaded(view: IWebPageListView)
}

protocol IWebPageListLoading: AnyObject {

}

protocol IWebPageListCollectionViewHandler: AnyObject {
    func getRowCountInSection() -> Int
    func rowForCell(collectionView: UICollectionView, at index: IndexPath) -> UICollectionViewCell
    func updateRow(at index: Int)
    func permitDeleting(at index: IndexPath) -> Bool
    func deleteRow(at index: IndexPath)
}
