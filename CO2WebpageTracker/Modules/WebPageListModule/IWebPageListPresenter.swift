//
//  IWebPageListPresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit
typealias IWebPageListPresenter = IWebPageListViewLifeCycle & IWebPageListTableViewHandler

protocol IWebPageListViewLifeCycle: AnyObject {
    func viewDidLoaded(view: IWebPageListView)
}

protocol IWebPageListTableViewHandler: AnyObject {
    func getRowCountInSection() -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
    func actionDidSwipeToDelete(at index: Int)
    func showDetailView(at index: Int)
    func sortByCO2()
    func sortByDate()
}


