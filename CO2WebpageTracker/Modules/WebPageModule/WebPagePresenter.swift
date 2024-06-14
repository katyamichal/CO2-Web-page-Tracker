//
//  WebPagePresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit
protocol IWebPagePresenter: AnyObject {
  func viewDidLoaded(view: IWebPageView)
    func getRowCountInSection() -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
}

final class WebPagePresenter {
    private weak var view: IWebPageView?
    private let dataService: IDataService
    private var viewData: WebPageViewData?
    private let webPageId: UUID
    
    init(dataService: IDataService, id: UUID) {
        self.dataService = dataService
        self.webPageId = id
    }
}

extension WebPagePresenter: IWebPagePresenter {
    func getRowCountInSection() -> Int {
        1
    }
    
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell {
        cell(for: tableView, at: index)
    }
    
    func viewDidLoaded(view: IWebPageView) {
        self.view = view
    }
}

private extension WebPagePresenter {
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
