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
    private let webPageURL: String?
    private let stepperDelegate = StepperDelegate()
    private lazy var viewDataConstructor = ViewDataConstructor(viewData: viewData)
    
    init(coordinator: Coordinator?, dataService: IDataService, webPageURL: String?) {
        self.dataService = dataService
        self.webPageURL = webPageURL
        self.coordinator = coordinator
        self.stepperDelegate.delegate = self
    }
}

extension WebPagePresenter {
    convenience init(coordinator: Coordinator, dataService: IDataService, data: WebsiteData) {
        self.init(coordinator: coordinator, dataService: dataService, webPageURL: nil)
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

// MARK: - Delegate methods

extension WebPagePresenter: IWebPagePresenter {
    func viewDidLoaded(view: IWebPageView) {
        self.view = view
        if webPageURL == nil {
            self.view?.update()
        } else {
            getData()
        }
    }
    
    func updateData(with image: UIImage) {
        viewData?.image = image
        saveWebPage()
        (coordinator as? WebPageCoordinator)?.dismissImagePicker()
    }
    
    func prepareToSave() {
        guard let viewData else { return }
        let isDublicated = dataService.findDublicate(with: viewData)
        switch isDublicated {
        case true:
            view?.showAlert(with: Constants.AlerMessagesType.webPageDublicated)
        case false:
            saveWebPage()
        }
    }
    
    func saveWebPage() {
        guard let viewData else { return }
        dataService.add(webPage: viewData) { [weak self] _ in
            self?.getData()
            self?.view?.update()
        }
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
    
    func deleteButtonDidPressed() {
        guard let viewData else { return }
        dataService.deleteWebPage(url: viewData.url)
        (coordinator as? WebPageCoordinator)?.backToDetail()
    }
    
    func saveState() {
        guard let webPageURL = webPageURL else { return }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var appState = self.appStateService.retrieve(with: webPageURL)
            if appState == nil {
                appState = AppState(url: webPageURL, isEditingMode: .edinitig, stepperValue: viewDataConstructor.stepperValue, previosValue: viewDataConstructor.previousValue)
            } else {
                appState?.stepperValue = viewDataConstructor.stepperValue
                appState?.previosValue = viewDataConstructor.previousValue
            }
            if let appState = appState {
                self.appStateService.save(appState: appState)
            }
        }
    }
    
    func checkForSafedState() {
        guard let webPageURL, let state = appStateService.retrieve(with: webPageURL), state.isEditingMode == .edinitig else { return }
        view?.isEdited = true
        recoverEditingState(with: state.stepperValue, and: state.previosValue)
    }
    
    func imagePickerDidCancel() {
        (coordinator as? WebPageCoordinator)?.dismissImagePicker()
    }
    
    func showImagePicker(with imagePicker: UIImagePickerController) {
        (coordinator as? WebPageCoordinator)?.showImagePicker(with: imagePicker)
    }
    
    func shareWebPage() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let url = self.createURLForShare() else {
                DispatchQueue.main.async {
                    self.view?.showMessage(with: "We couldn'n create URL to share")
                }
                return
            }
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityVC.excludedActivityTypes = [.airDrop]
                (self.coordinator as? WebPageCoordinator)?.presentView(with: activityVC)
            }
        }
    }
}

// MARK: - Stepper Delegate

extension WebPagePresenter: IStepperDelegate {
    func didChanged(with value: Int, and maxValue: Int) {
        let previousValue: Int = viewDataConstructor.previousValue
        var currentvValue: Int
        
        if value < maxValue && value > previousValue  {
            currentvValue = Int(value - 1) * 10
        } else {
            currentvValue = Int(value + 1) / 10
        }
        viewDataConstructor.stepperValue = currentvValue
        viewDataConstructor.previousValue = currentvValue
        view?.updateEnergyWasteTypeCell()
    }
}

// MARK: - Private methods

private extension WebPagePresenter {
    func getData() {
        guard let webPageURL else { return }
        dataService.fetchWepPage(with: webPageURL) { [weak self] data in
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
    
    func recoverEditingState(with stepperValue: Int, and previosValue: Int) {
        viewDataConstructor.stepperValue = stepperValue
        viewDataConstructor.previousValue = previosValue
    }
    
    func createURLForShare() -> URL? {
      guard let viewDataURLString = viewData?.url,
            let viewDataURL = URL(string: viewDataURLString) else {
                print("viewData or url is nil or invalid")
                return nil
            }
        let baseURLString = Constants.BaseUrls.websitecarbon
        guard var host = viewDataURL.host else {
            print("Invalid URL host")
            return nil
        }
        if host.hasPrefix("www.") {
            host.removeFirst(4)
        }
        
        let urlString = baseURLString + "\(host)/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        return url
    }
}




