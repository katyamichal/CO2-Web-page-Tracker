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
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
}

extension WebPageListPresenter: IWebPageListPresenter {
    func sortByDate() {
        viewData.sort(by: {$0.date > $1.date})
        view?.update()
    }
    
    func sortByCO2() {
        viewData.sort(by: {$0.rating < $1.rating})
        view?.update()
    }
    
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
        dataService.deleteWebPage(url: viewData[index].url)
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
        dataService.fetchWepPages { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataService.performFetch()
                self?.viewData = data
            case .failure(let error):
                print(error)
            }
            self?.view?.update()
        }
        print(viewData.count)
    }
    
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WebPageListTableViewCell.reuseIdentifier, for: indexPath) as? WebPageListTableViewCell else {
            return UITableViewCell()
        }
        let data = viewData[indexPath.row]
        let testDate = dateFormatter.string(from: data.date)
        cell.updateLabels(url: data.url, rating: data.rating, date: testDate)
        return cell
    }
}
