//
//  CarbonRatingCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit
final class CarbonRatingCell: UITableViewCell {
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 8
    
    static var reuseIdentifier: String {
        return String(describing: CarbonRatingCell.self)
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var stackView: UIStackView = {
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
    
    private lazy var letterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var resultForLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var dirtierThatLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    // charts
    
    // leart about
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    override func prepareForReuse() {
        letterLabel.text = nil
        resultForLabel.text = nil
        descriptionLabel.text = nil
        dirtierThatLabel.text = nil
        super.prepareForReuse()
    }
}

private extension CarbonRatingCell {
    func setupCell() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(letterLabel)
        stackView.addArrangedSubview(resultForLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dirtierThatLabel)
    }
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
