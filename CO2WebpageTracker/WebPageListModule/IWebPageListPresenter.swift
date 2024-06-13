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
    func loadData(with keyword: String)
    func updateViewData(with id: UUID)
}

protocol IWebPageListTableViewHandler: AnyObject {
    func getRowCountInSection() -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
    func updateRow(at index: Int)
    func heightForRow(at index: Int) -> CGFloat
    func permitDeleting(at index: IndexPath) -> Bool
    func deleteRow(at index: IndexPath)
}
