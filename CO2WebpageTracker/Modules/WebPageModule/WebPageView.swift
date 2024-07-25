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
        tableView.backgroundColor = .clear
        tableView.separatorColor = .black
        tableView.register(CarbonRatingCell.self, forCellReuseIdentifier: CarbonRatingCell.reuseIdentifier)
        tableView.register(EnergyWasteTypeCell.self, forCellReuseIdentifier: EnergyWasteTypeCell.reuseIdentifier)
        tableView.register(RenewableCell.self, forCellReuseIdentifier: RenewableCell.reuseIdentifier)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var saveDeleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    func setSaveDeleteButtonTitle(_ title: String) {
        saveDeleteButton.setTitle(title, for: .normal)
    }
    
    func setSaveDeleteButtonAction(_ target: Any, action: Selector, for event: UIControl.Event = .touchDown) {
        saveDeleteButton.addTarget(target, action: action, for: event)
    }
    
    func setSaveDeleteButtonColour(_ colour: UIColor) {
        saveDeleteButton.backgroundColor = colour
    }
}

private extension WebPageView {
    func setupView() {
        backgroundColor = Colours.BackgroundsColours.light
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(tableView)
        addSubview(saveDeleteButton)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: saveDeleteButton.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        saveDeleteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        saveDeleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveDeleteButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        saveDeleteButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
    }
    
}
