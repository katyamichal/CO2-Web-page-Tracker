//
//  IWebPagePresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 20.06.2024.
//

import UIKit

typealias IWebPagePresenter = IWebPageViewLifeCycle & IWebPageTableViewHandler & IWebPagePersistence & IWebPageLogic

protocol IWebPageViewLifeCycle: AnyObject {
    func viewDidLoaded(view: IWebPageView)
}

protocol IWebPageTableViewHandler: AnyObject {
    var isWebPageExisted: Bool { get }
    
    var sectionCount: Int { get }
    func getRowCountInSection(at section: Int) -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
}

protocol IWebPagePersistence: AnyObject {
    func saveButtonDidPressed()
    func updateData(with image: UIImage)
    func updateWebPage()
    func deleteButtonDidPressed()

    func checkForSavedState()
    func saveState()
}

protocol IWebPageLogic: AnyObject {
    func showImagePicker(with imagePicker: UIImagePickerController)
    func imagePickerDidCancel()
    func prepareToShare()
    func share(with activityViewController: UIActivityViewController)
    func addReminderButtonDidTapped()
}
