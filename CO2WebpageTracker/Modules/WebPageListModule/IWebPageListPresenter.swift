//
//  IWebPageListPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit
typealias IWebPageListPresenter = IWebPageListViewLifeCycle & IWebPageListLoading & IWebPageListTableViewHandler

protocol IWebPageListViewLifeCycle: AnyObject {
    func viewDidLoaded(view: IWebPageListView)
}

protocol IWebPageListLoading: AnyObject {

}

protocol IWebPageListTableViewHandler: AnyObject {
    func getRowCountInSection() -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
    func updateRow(at index: Int)
    func permitDeleting(at index: IndexPath) -> Bool
    func actionDidSwipeToDelete(at index: Int)
    func showDetailView(at index: Int)
    func sortByCO2()
}


