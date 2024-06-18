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
    func deleteButtonDidPressed()
    func saveButtonDidPressed()
}

final class WebPagePresenter {
    
    private weak var coordinator: Coordinator?
    private weak var view: IWebPageView?
    private var dataService: IDataService
    private var viewData: WebPageViewData?
    
    private let webPageId: UUID?
    private let stepperDelegate = StepperDelegate()
    private var stepperValue: Int = 1
    private lazy var dataMapper = DataMapper(viewData: viewData)
    
    init(coordinator: Coordinator?, dataService: IDataService, id: UUID?) {
        self.dataService = dataService
        self.webPageId = id
        self.coordinator = coordinator
        self.stepperDelegate.delegate = self
    }
}

extension WebPagePresenter {
    convenience init(coordinator: Coordinator, dataService: IDataService, data: WebsiteData) {
        self.init(coordinator: coordinator, dataService: dataService, id: nil)
        self.viewData = WebPageViewData(
            url: data.url,
            date: Date(),
            cleanerThan: data.cleanerThan,
            ratingLetter: data.rating,
            isGreen: convertGreenToString(data.green),
            gramForVisit: Double(data.statistics.energy),
            energy: data.statistics.co2.renewable.grams)
    }
}

extension WebPagePresenter: IWebPagePresenter {
    func saveButtonDidPressed() {
        guard let viewData else { return }
        dataService.add(webPage: viewData) { [weak self] result in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteButtonDidPressed() {
        guard let webPageId else { return }
        dataService.deleteWebPage(with: webPageId)
        (coordinator as? WebPageListCoordinator)?.dismiss(with: coordinator)
    }
    
    
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
            cell.update(with: dataMapper.ratingColor, with: viewData.ratingLetter, description: dataMapper.ratingDescription, url: dataMapper.urlDescription, cleanerThan: dataMapper.cleanerThanDescription, date: dataMapper.lastTestDate)
            
            return cell
            
        case .renewable:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RenewableCell.reuseIdentifier, for: indexPath) as? RenewableCell else {
                return UITableViewCell()
            }
            cell.update(with: dataMapper.co2PerPageviewDescription, energyType: dataMapper.greenDescription)
            return cell
            
        case .energyType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnergyWasteTypeCell.reuseIdentifier, for: indexPath) as? EnergyWasteTypeCell else {
                return UITableViewCell()
            }
            cell.update(with: dataMapper.energy, stepperValue: dataMapper.stepperValue)
            cell.configureStepperDelgate(with: stepperDelegate)
            return cell
        }
    }
    
    func convertGreenToString(_ isGreen: BoolOrString) -> String {
        switch isGreen {
        case .bool(let status):
            switch status {
            case true:
                return "true"
            case false:
                return "false"
            }
        case .string(let str):
            return str
        }
    }
}

extension WebPagePresenter: IStepperDelegate {
    func didChanged(with value: Int) {
        stepperValue = value
        view?.updateEnergyWasteTypeCell()
    }
}
