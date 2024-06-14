//
//  WebPageListTableViewCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import Foundation
import UIKit

final class WebPageListCollectionViewCell: UICollectionViewCell {
    
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 8
    
    static var reuseIdentifier: String {
        return String(describing: WebPageListCollectionViewCell.self)
    }

    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var webPageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = spacing
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = .black
        return label
    }()
    

    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Public
    
    override func prepareForReuse() {
        dateLabel.text = nil
        urlLabel.text = nil
        super.prepareForReuse()
    }
}

// MARK: - Setup methods

private extension WebPageListCollectionViewCell {
    func setupCell() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(webPageStackView)
        webPageStackView.addArrangedSubview(dateLabel)
        webPageStackView.addArrangedSubview(urlLabel)
    }
    
    func setupConstraints() {
        webPageStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        webPageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        webPageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        webPageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
