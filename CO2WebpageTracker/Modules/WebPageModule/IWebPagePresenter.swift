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
    var buttonTitle: String { get }
    var buttonColour: UIColor { get }
    
    var sectionCount: Int { get }
    func getRowCountInSection(at section: Int) -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
}

protocol IWebPagePersistence: AnyObject {
    func updateData(with image: UIImage)
    func deleteButtonDidPressed()
    func prepareToSave()
    func updateWebPage()
    func checkForSafedState()
    func saveState()
    func saveOrDelete()
}

protocol IWebPageLogic: AnyObject {
    func showImagePicker(with imagePicker: UIImagePickerController)
    func imagePickerDidCancel()
    func prepareToShare()
    func share(with activityViewController: UIActivityViewController)
}
