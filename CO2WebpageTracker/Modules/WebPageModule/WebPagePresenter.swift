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
    private let webPageURL: String?
    
    private let appStateService = AppStateService.shared
  
    private let linkButtonDelegate = LinkButtonDelegate()
    private let stepperDelegate = StepperDelegate()
    private lazy var viewDataConstructor = ViewDataConstructor(viewData: viewData)
    
    init(coordinator: Coordinator?, dataService: IDataService, webPageURL: String?) {
        self.dataService = dataService
        self.webPageURL = webPageURL
        self.coordinator = coordinator
        self.stepperDelegate.delegate = self
        self.linkButtonDelegate.delegate = self
    }
    
    deinit {
        print("WebPageView Deinit")
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
            isGreen: ViewDataConstructor.convertGreenToString(data.green),
            gramForVisit: Double(data.statistics.energy),
            energy: data.statistics.co2.renewable.grams)
    }
}

// MARK: - Delegate methods

extension WebPagePresenter: IWebPageViewLifeCycle {
    func viewDidLoaded(view: IWebPageView) {
        self.view = view
        if webPageURL == nil {
            self.view?.update()
        } else {
            getData()
        }
    }
}

extension WebPagePresenter:  IWebPageTableViewHandler {
    var isWebPageExisted: Bool {
        (webPageURL == nil) ? true : false
    }
    
    // MARK: - Table Data Source Handeling
    
    var sectionCount: Int {
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
}

extension WebPagePresenter:  IWebPagePersistence {
    
    // MARK: - Updating WebPage with image
    
    func updateData(with image: UIImage) {
        viewData?.image = image
        guard let viewData else { return }
        let isDublicated = dataService.findDublicate(with: viewData)
        switch isDublicated {
        case true:
            updateWebPage()
        case false:
            break
        }
        (coordinator as? WebPageCoordinator)?.dismissImagePicker()
    }
    
    // MARK: - Saving Web Page
    
    func saveButtonDidPressed() {
        prepareToSave()
    }
    
    func updateWebPage() {
        guard let viewData else { return }
        dataService.update(webPage: viewData)
        getData()
    }
    
    // MARK: - Deleting Web Page
    
    func deleteButtonDidPressed() {
        guard let webPageURL else { return }
        dataService.deleteWebPage(url: webPageURL)
        (coordinator as? WebPageCoordinator)?.goBack()
    }
    
    // MARK: - App State
    
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
    
    func checkForSavedState() {
        guard let webPageURL, let state = appStateService.retrieve(with: webPageURL),
              state.isEditingMode == .edinitig else { return }
        recoverEditingState(with: state.stepperValue, and: state.previosValue)
    }
}

extension WebPagePresenter: IWebPageLogic {
    
    // MARK: - Image Picker Logic
    
    func imagePickerDidCancel() {
        (coordinator as? WebPageCoordinator)?.dismissImagePicker()
    }
    
    func showImagePicker(with imagePicker: UIImagePickerController) {
        (coordinator as? WebPageCoordinator)?.showImagePicker(with: imagePicker)
    }
    
    // MARK: - Share WebPage
    
    func prepareToShare() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let viewData,
                  let url = URLConstructor.createURLForShare(with: viewData.url) else {
                DispatchQueue.main.async {
                    self.view?.showMessage(with: "We couldn't create URL to share")
                }
                return
            }
            DispatchQueue.main.async {
                self.view?.prepareToShareWebPage(with: url)
            }
        }
    }
    
    func share(with activityViewController: UIActivityViewController) {
        (coordinator as? WebPageCoordinator)?.presentView(with: activityViewController)
    }
    
    // MARK: - Reminder

    func addReminderButtonDidTapped() {
        (coordinator as? WebPageCoordinator)?.showReminderModule()
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

extension WebPagePresenter: ILinkButtonDelegate {
    func howDoesItWorkDidTapped() {
        guard let viewData else { return }
        (coordinator as? WebPageCoordinator)?.showWebKit(with: viewData.howDoesItWork)
    }
    
    func learnAboutButtonDidTapped() {
        guard let viewData else { return }
        (coordinator as? WebPageCoordinator)?.showWebKit(with: viewData.learnAboutURLString)
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
        }
        (coordinator as? WebPageCoordinator)?.goBack()
    }
    
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let section = WebPageSection.allCases[indexPath.section]
        
        guard let viewData else { return UITableViewCell() }
        switch section {
        case .carbonRating:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CarbonRatingCell.reuseIdentifier, for: indexPath) as? CarbonRatingCell else {
                return UITableViewCell()
            }
            cell.update(with: viewDataConstructor.ratingColor, with: viewData.ratingLetter, description: viewDataConstructor.ratingDescription, url: viewDataConstructor.urlDescription, cleanerThan: viewDataConstructor.cleanerThanDescription, buttonTitle: viewDataConstructor.learnAboutButtonTitle, date: viewDataConstructor.lastTestDate)
            cell.configureLearnAboutButtonDelgate(with: linkButtonDelegate)
            return cell
            
        case .renewable:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RenewableCell.reuseIdentifier, for: indexPath) as? RenewableCell else {
                return UITableViewCell()
            }
            cell.update(with: viewDataConstructor.co2PerPageviewDescription, energyType: viewDataConstructor.greenDescription, buttonTitle: viewDataConstructor.howDoesItWorkButtonTitle)
            cell.configureLinkButtonDelgate(with: linkButtonDelegate)
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
}




