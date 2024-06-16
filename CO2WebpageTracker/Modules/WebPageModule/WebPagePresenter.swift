//
//  WebPagePresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

protocol IWebPagePresenter: AnyObject {
    func viewDidLoaded(view: IWebPageView)
    func getSectionCount() -> Int
    func getRowCountInSection(at section: Int) -> Int
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
        //dataService.add(webPage: WebPageViewData(url: "www.apple.com", date: Date(), rating: "B", isGreen: true, gramForVisit: 0.23))
    }
}

extension WebPagePresenter: IWebPagePresenter {

    func getSectionCount() -> Int {
        WebPageSection.allCases.count
       }
    
    func getRowCountInSection(at section: Int) -> Int {
        let section = WebPageSection.allCases[section]
         guard let viewData else { return 0 }
         switch section {
         case .energyType, .carbonRating, .renewable:
             return 1
         }
    }
    
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell {
        cell(for: tableView, at: index)
    }
    
    func viewDidLoaded(view: IWebPageView) {
        self.view = view
        getData()
    }
}

private extension WebPagePresenter {
    func getData() {
        dataService.fetchWepPage(with: webPageId) { [weak self] data in
            self?.viewData = data
            self?.view?.update()
        }
    }
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let section = WebPageSection.allCases[indexPath.section]
        
          guard let viewData else { return UITableViewCell() }
        
          switch section {
          case .carbonRating:
              guard let cell = tableView.dequeueReusableCell(withIdentifier: CarbonRatingCell.reuseIdentifier, for: indexPath) as? CarbonRatingCell else {
                  return UITableViewCell()
              }
              cell.update(with: viewData.rating)
              return cell

          case .energyType:
              guard let cell = tableView.dequeueReusableCell(withIdentifier: EnergyTypeCell.reuseIdentifier, for: indexPath) as? EnergyTypeCell else {
                  return UITableViewCell()
              }
              cell.update(with: (viewData.isGreen) ? "Green Energe" : "Not green Energy")
              return cell

          case .renewable:
              guard let cell = tableView.dequeueReusableCell(withIdentifier: RenewableCell.reuseIdentifier, for: indexPath) as? RenewableCell else {
                  return UITableViewCell()
              }
              cell.update(with: String(describing: viewData.gramForVisit))
              return cell
          }
    }
}
