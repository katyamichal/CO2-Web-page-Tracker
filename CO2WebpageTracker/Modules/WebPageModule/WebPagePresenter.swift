//
//  WebPagePresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class WebPagePresenter {
    
    private weak var coordinator: Coordinator?
    private weak var view: IWebPageView?
    private var dataService: IDataService
    private var viewData: WebPageViewData?
    private let appStateService = AppStateService.shared
    private let webPageId: UUID?
    private let stepperDelegate = StepperDelegate()
    private lazy var viewDataConstructor = ViewDataConstructor(viewData: viewData)
    
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
#warning("ask for self.saveWebPage()")
extension WebPagePresenter: IWebPagePresenter {
    
    func updateData(with image: UIImage) {
        viewData?.image = image
        view?.update()
        if let webPageId {
            var appState = AppState(with: webPageId, isEditing: .edinitig, currentTab: .webPageList, image: image)
            appStateService.save(appState: appState)
        }
    }
    
    func recoverEditingState() {
        let appState = appStateService.retrieve()
        viewData?.image = appState?.image
        view?.update()
    }
    
    func prepareToSave() {
        guard let viewData else { return }
        let isDublicated = dataService.findDublicate(with: viewData)
        switch isDublicated {
        case true:
            view?.showAlert(with: Constants.AlerMessagesType.webPageDublicated)
        case false:
            if let webPageId {
                var appState = appStateService.retrieve()
                appStateService.delete()
                
            }
            self.saveWebPage()
        }
    }
    
    func saveWebPage() {
        guard let viewData else { return }
        dataService.add(webPage: viewData) { [weak self] message in
            self?.view?.showMessage(with: message)
            self?.getData()
        }
    }
    #warning("dismiss")
    func deleteButtonDidPressed() {
        guard let viewData else { return }
        dataService.deleteWebPage(url: viewData.url)
        (coordinator as? WebPageCoordinator)?.dismiss()
    }
    
    func getSectionCount() -> Int {
        WebPageSection.allCases.count
    }
    
    func getRowCountInSection(at section: Int) -> Int {
        let section = WebPageSection.allCases[section]
        guard viewData != nil else { return 0 }
        switch section {
        case .energyType, .carbonRating, .renewable:
            return 1
        case .image:
            return (viewData?.image != nil) ? 1 : 0
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

extension WebPagePresenter: IStepperDelegate {
    func didChanged(with value: Int) {
        viewDataConstructor.stepperValue = value
        view?.updateEnergyWasteTypeCell()
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
            cell.update(with: viewDataConstructor.ratingColor, with: viewData.ratingLetter, description: viewDataConstructor.ratingDescription, url: viewDataConstructor.urlDescription, cleanerThan: viewDataConstructor.cleanerThanDescription, date: viewDataConstructor.lastTestDate)
            
            return cell
            
        case .renewable:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RenewableCell.reuseIdentifier, for: indexPath) as? RenewableCell else {
                return UITableViewCell()
            }
            cell.update(with: viewDataConstructor.co2PerPageviewDescription, energyType: viewDataConstructor.greenDescription)
            return cell
            
        case .energyType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EnergyWasteTypeCell.reuseIdentifier, for: indexPath) as? EnergyWasteTypeCell else {
                return UITableViewCell()
            }
            cell.update(visitCount: viewDataConstructor.energyHeadTitle, energy: viewDataConstructor.energy, stepperValue: viewDataConstructor.stepperValue)
            cell.configureStepperDelgate(with: stepperDelegate)
            return cell
        case .image:
            guard let image = viewData.image, let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
                return UITableViewCell()
            }
            cell.update(with: viewDataConstructor.urlTitle, and: image)
            return cell
        }
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
    
    func configureDataServiceResponse(with type: CoreDataErrors) -> String {
        switch type {
        case .fetchError:
            return Constants.CoreDataMessage.fetchError
        case .dublicate:
            return Constants.CoreDataMessage.fetchError
        }
    }

