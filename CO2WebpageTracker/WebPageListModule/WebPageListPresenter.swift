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
    
    func loadData(with keyword: String) {
    }
    
    func updateViewData(with id: UUID) {
        
    }
    
    func getRowCountInSection() -> Int {
        viewData.count
    }
    
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell {
        cell(for: tableView, at: index)
    }
    
    func updateRow(at index: Int) {
        
    }
    
    func heightForRow(at index: Int) -> CGFloat {
        3.0
    }
    
    func permitDeleting(at index: IndexPath) -> Bool {
        true
    }
    
    func deleteRow(at index: IndexPath) {
    
    }
}

private extension WebPageListPresenter {
 
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WebPageListTableViewCell.reuseIdentifier, for: indexPath) as? WebPageListTableViewCell else {
            return UITableViewCell()
        }
        let data = viewData[indexPath.row]
   
        return cell
    }
}
