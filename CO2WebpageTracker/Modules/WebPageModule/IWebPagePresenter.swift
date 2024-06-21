//
//  IWebPagePresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 20.06.2024.
//

import UIKit

typealias IWebPagePresenter = IWebPageViewLifeCycle & IWebPageTableViewHandler

protocol IWebPageViewLifeCycle: AnyObject {
    func viewDidLoaded(view: IWebPageView)
    func checkForSafedState()
    func saveState()
}

protocol IWebPageTableViewHandler: AnyObject {
    func getSectionCount() -> Int
    func getRowCountInSection(at section: Int) -> Int
    func rowForCell(tableView: UITableView, at index: IndexPath) -> UITableViewCell
    func deleteButtonDidPressed()
    func prepareToSave()
    func saveWebPage()
    func updateData(with image: UIImage)
    func showImagePicker(with imagePicker: UIImagePickerController)
    func imagePickerDidCancel()
}
