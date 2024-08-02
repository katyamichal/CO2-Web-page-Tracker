//
//  LinkButtonDelegate.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import Foundation

protocol ILinkButtonDelegate: AnyObject {
    func learnAboutButtonDidTapped()
    func howDoesItWorkDidTapped()
}

final class LinkButtonDelegate {
    weak var delegate: ILinkButtonDelegate?
}

extension LinkButtonDelegate: ILearnAboutDelegate {
    func buttonDidTapped() {
        delegate?.learnAboutButtonDidTapped()
    }
}

extension LinkButtonDelegate: IHowDoesItWorkButtonDelegate {
    func howDoesItWorkButtoDidTapped() {
        delegate?.howDoesItWorkDidTapped()
    }
}
