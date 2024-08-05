//
//  ReminderView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 05.08.2024.
//

import UIKit

final class ReminderView: UICollectionView {
    
    // MARK: - Init

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: -

}

private extension ReminderView {
    func setupView() {

        backgroundColor = .yellow
    }
}
