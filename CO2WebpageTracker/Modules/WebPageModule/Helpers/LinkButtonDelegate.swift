//
//  LinkButtonDelegate.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import Foundation

protocol ILinkButtonDelegate: AnyObject {
    func learnAboutButtonDidTapped()
    // how do we calculate this button
    // how do we find out this button
}

final class LinkButtonDelegate {
    weak var delegate: ILinkButtonDelegate?
}

extension LinkButtonDelegate: ILearnAboutDelegate {
    func buttonDidTapped() {
        delegate?.learnAboutButtonDidTapped()
    }
}
