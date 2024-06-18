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
        dataService.add(webPage: viewData)
        
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
            cell.update(with: ratingColor, with: viewData.ratingLetter, description: ratingDescription, url: urlDescription, cleanerThan: cleanerThanDescription, date: "20.04.34")
            
            return cell
            
        case .renewable:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RenewableCell.reuseIdentifier, for: indexPath) as? RenewableCell else {
                return UITableViewCell()
            }
            cell.update(with: co2PerPageviewDescription, energyType: greenDescription)
            return cell
            
        case .energyType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnergyWasteTypeCell.reuseIdentifier, for: indexPath) as? EnergyWasteTypeCell else {
                return UITableViewCell()
            }
            cell.update(with: energy, stepperValue: stepperValue)
            cell.configureStepperDelgate(with: stepperDelegate)
            return cell
        }
    }
}

// MARK: - Configure Descriptions for Table View

private extension WebPagePresenter {
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
    
    var urlDescription: String {
        guard let viewData else { return "No Data" }
        return (DescriptionConstructor.shared.getDescription(for: "url") as? String ?? "") + " " + viewData.url
    }
    
    var scaleDescription: [String: [String: Any]]? {
        return DescriptionConstructor.shared.getScaleRating()
    }
    
    var greenDescription: String {
        guard let viewData else { return "No Data" }
        return DescriptionConstructor.shared.getGreenDescription(isGreen: viewData.isGreen)
    }
    
    var cleanerThanDescription: String {
        guard let viewData else { return "No Data" }
        return ((DescriptionConstructor.shared.getDescription(for: "cleanerThan") as? String ?? "") + "\(Int(viewData.cleanerThan * 100))" + "%")
    }
    
    var co2PerPageviewDescription: String {
        guard let viewData else { return "No Data" }
        return (String(format: "%.2f", viewData.energy)) + " " + (DescriptionConstructor.shared.getDescription(for: "co2PerPageview") as? String ?? "").lowercased()
    }
    
    var ratingColor: UIColor {
        guard
            let viewData,
            let letterColour = DescriptionConstructor.shared.getRatingLetter(with: viewData.ratingLetter)?.lowercased(),
            let colour = UIColor.init(hex: letterColour)
        else { return UIColor.gray }
        return colour
    }
    
    var ratingDescription: String {
        guard let viewData else { return "No Data" }
        return DescriptionConstructor.shared.getRatingDescription(with: viewData.ratingLetter)
    }
    var energy: String {
        guard let viewData else { return "No Data" }
        return String(format: "%.2f", (viewData.energy * Double(stepperValue)))
    }
}

extension WebPagePresenter: IStepperDelegate {
    func didChanged(with value: Int) {
//        print("\(value)")
        stepperValue = value
        view?.updateEnergyWasteTypeCell()
    }
}
