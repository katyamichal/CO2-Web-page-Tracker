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
    
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell {
        cell(for: tableView, at: index)
    }
    
    func updateRow(at index: Int) {
        
    }
    
    func permitDeleting(at index: IndexPath) -> Bool {
        true
    }
    
    func actionDidSwipeToDelete(at index: Int) {
        guard index < viewData.count else { return }
        dataService.deleteWebPage(with: viewData[index].id)
    }
}


extension WebPageListPresenter: IFetchResultControllerDelegate {
    func beginUpdating() {
        view?.beginUpdate()
    }
    
    func endUpdating() {
        view?.endUpdate()
    }
    
    func insertObject(at index: IndexPath, with object: WebPageListViewData) {
        viewData.insert(object, at: index.row)
        view?.insertRow(at: index)
    }
    
    func objectDidChange(at index: IndexPath, with object: WebPageListViewData) {
        viewData[index.row] = object
        view?.update()
    }
        
    func deleteRow(at index: IndexPath) {
        viewData.remove(at: index.row)
        view?.deleteRow(at: index)
    }
}
#warning("Ask about     self.dataService.performFetch()")
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
    
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WebPageListTableViewCell.reuseIdentifier, for: indexPath) as? WebPageListTableViewCell else {
            return UITableViewCell()
        }
        let data = viewData[indexPath.row]

        cell.updateLabels(url: data.url, rating: data.rating, date: "12.05.23")
        return cell
    }
    
    func generateSampleWebPageData() -> [WebPageListViewData] {
        return [
            WebPageListViewData(url: "https://example.com", date: Date(), rating: "A"),
        ]
    }
}
