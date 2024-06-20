//
//  ISearchWebPagePresenter.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 20.06.2024.
//

import Foundation

protocol ISearchWebPagePresenter: AnyObject {
    func viewDidLoaded(view: ISearchWebPageView)
    func prepareToLoad(with url: String) -> Bool
    func loadData(with url: String)
    func updateViewData()
    func tryAgainButtonPressed()
    func changeLoadingStatus()
}
