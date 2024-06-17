//
//  WebPageView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class WebPageView: UIView {
    private let inset: CGFloat = 8

    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CarbonRatingCell.self, forCellReuseIdentifier: CarbonRatingCell.reuseIdentifier)
        tableView.register(EnergyWasteTypeCell.self, forCellReuseIdentifier: EnergyWasteTypeCell.reuseIdentifier)
        tableView.register(RenewableCell.self, forCellReuseIdentifier: RenewableCell.reuseIdentifier)
        return tableView
    }()
}

private extension WebPageView {
    func setupView() {
        backgroundColor = Colours.WebPageColours.green
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
}
