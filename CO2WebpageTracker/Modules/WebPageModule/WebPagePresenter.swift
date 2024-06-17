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
    private weak var coordinator: Coordinator?
    private weak var view: IWebPageView?
    private var dataService: IDataService
    private var viewData: WebPageViewData?
    private let webPageId: UUID?
    
    init(coordinator: Coordinator?, dataService: IDataService, id: UUID?) {
        self.dataService = dataService
        self.webPageId = id
        self.coordinator = coordinator
//        dataService.add(webPage: WebPageViewData(url: "www.apple.com", date: Date(), diertierThan: 60, ratingLetter: "D", isGreen: false, gramForVisit: 0.3, energy: 0.1))
    }
}

extension WebPagePresenter {
    convenience init(coordinator: Coordinator, dataService: IDataService, data: WebsiteData) {
        self.init(coordinator: coordinator, dataService: dataService, id: nil)

        self.viewData = WebPageViewData(url: data.url, date: Date(), diertierThan: Int(data.cleanerThan), ratingLetter: data.rating, isGreen: data.green, gramForVisit: Float(data.statistics.energy), energy: data.statistics.co2.renewable.grams
        )
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
        if webPageId == nil {
            self.view?.update()
        } else {
            getData()
        }
    }
}

private extension WebPagePresenter {
    func getData() {
        guard let webPageId else { return }
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
            let color = UIColor.init(hex: viewData.ratingColor) ?? UIColor.gray
            cell.update(with: color, with: viewData.ratingLetter, description: viewData.ratingDescription, url: viewData.urlDescription, diertierThan: String(describing: viewData.diertierThan), date: "20.04.34")
            
            return cell
            
        case .energyType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnergyWasteTypeCell.reuseIdentifier, for: indexPath) as? EnergyWasteTypeCell else {
                return UITableViewCell()
            }
            cell.update(with: String(viewData.energy))
            return cell
            
        case .renewable:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RenewableCell.reuseIdentifier, for: indexPath) as? RenewableCell else {
                return UITableViewCell()
            }
            cell.update(with: viewData.co2PerPageviewDescription, energyType: viewData.greenDescription)
            return cell
        }
    }
}
