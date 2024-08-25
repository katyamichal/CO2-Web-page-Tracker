//
//  WebPageViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit
protocol IWebPageView: AnyObject {
    func update()
    func setupNavigationTitle(with title: String)
    func updateEnergyWasteTypeCell()
    func showAlert(with type: Constants.AlerMessagesType)
    func showMessage(with message: String)
    func prepareToShareWebPage(with webPage: URL)
}

final class WebPageViewController: UIViewController {
    private var webPageView: WebPageView { return self.view as! WebPageView }
    private let presenter: IWebPagePresenter
    
    // MARK: - Inits
    
    init(presenter: IWebPagePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        print("WebPageViewController Init")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WebPageViewController Deinit")
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        view = WebPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded(view: self)
        setupTableViewDelegates()
        setupNavigationBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.checkForSavedState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.saveState()
    }
}

extension WebPageViewController: IWebPageView {
    func update() {
        webPageView.tableView.reloadData()
    }
    
    func setupNavigationTitle(with title: String) {
        navigationItem.title = title
    }
    
    func updateEnergyWasteTypeCell() {
        let indexPath = IndexPath(row: 0, section: WebPageSection.energyType.rawValue)
        webPageView.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert(with type: Constants.AlerMessagesType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: type.cancelButtonTitle, style: .cancel)
        let resaveAction = UIAlertAction(title: type.actionButtonTitle, style: .default) { _ in
            self.presenter.updateWebPage()
        }
        alert.addAction(cancelAction)
        alert.addAction(resaveAction)
        self.present(alert, animated: true)
    }
    
    func showMessage(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func prepareToShareWebPage(with webPage: URL) {
        let activityVC = UIActivityViewController(activityItems: [webPage], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop]
        presenter.share(with: activityVC)
    }
}

extension WebPageViewController: UITableViewDelegate {}

extension WebPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getRowCountInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.rowForCell(tableView: tableView, at: indexPath)
    }
}

// MARK: - Image Picker Delegates

extension WebPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presenter.showImagePicker(with: imagePicker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            presenter.updateData(with: theImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.imagePickerDidCancel()
    }
}


private extension WebPageViewController {
    func setupTableViewDelegates() {
        webPageView.tableView.dataSource = self
        webPageView.tableView.delegate = self
    }
    
    func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [createBarMenuButton()]
        if presenter.isWebPageExisted {
            navigationItem.rightBarButtonItems?.append(createSaveBarButton())
            
        } else {
            navigationItem.rightBarButtonItems?.append(createDeleteBarButton())
        }
    }
    
    // MARK: - Bar Buttons
    
    func createBarMenuButton() -> UIBarButtonItem {
        let pointSize: CGFloat = 20
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .light)
        let image = UIImage(systemName: Constants.UIElementSystemNames.actionMenu, withConfiguration: configuration)
        let rightBarItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        rightBarItem.tintColor = .systemBackground
        
        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: Constants.UIElementTitle.share, image: UIImage(systemName: Constants.UIElementSystemNames.share)) {  [weak self] action in
                self?.shareWebPage(action: action)
            },
 
            UIAction(title: Constants.UIElementTitle.addPhoto, image: UIImage(systemName: Constants.UIElementSystemNames.camera)) { [weak self] action in
                self?.addPhoto(action: action)
            }
        ])
        rightBarItem.menu = barButtonMenu
        rightBarItem.tintColor = Colours.WebPageColours.darkOrange
        return rightBarItem
    }
    
    
    func shareWebPage(action: UIAction) {
        presenter.prepareToShare()
    }
    
    func addPhoto(action: UIAction) {
        choosePhotoFromLibrary()
    }
    
    func createSaveBarButton() -> UIBarButtonItem {
        let saveBarButton = UIBarButtonItem(title: Constants.UIElementTitle.save, style: .plain, target: self, action: #selector(saveWebPage))
        return saveBarButton
    }
    
    func createDeleteBarButton() -> UIBarButtonItem {
        let deleteBarButton = UIBarButtonItem(title: Constants.UIElementTitle.delete, style: .plain, target: self, action: #selector(deeleteWebPage))
        return deleteBarButton
    }
    
    @objc
    func saveWebPage() {
        presenter.saveButtonDidPressed()
    }
    
    @objc
    func deeleteWebPage() {
        presenter.deleteButtonDidPressed()
    }
}
