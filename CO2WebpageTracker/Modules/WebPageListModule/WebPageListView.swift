//
//  WebPageView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

final class WebPageListView: UIView {
    
    private let inset: CGFloat = 8
    private let searchFieldHeight: CGFloat = 40
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Element
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(WebPageListTableViewCell.self, forCellReuseIdentifier: WebPageListTableViewCell.reuseIdentifier)
        return tableView
    }()
}

private extension WebPageListView {
    func setupView() {
        backgroundColor = Colours.WebPageColours.khaki
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

}
