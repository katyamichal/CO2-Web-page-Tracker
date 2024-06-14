//
//  WebPageView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class WebPageView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(CarbonRatingCell.self, forCellReuseIdentifier: CarbonRatingCell.reuseIdentifier)
//        tableView.register(TableViewHeader.self, forHeaderFooterViewReuseIdentifier: TableViewHeader.reuseIdentifier)
        return tableView
    }()
}
