//
//  RenewableCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

protocol IHowDoesItWorkButtonDelegate: AnyObject {
    func howDoesItWorkButtoDidTapped()
}

final class RenewableCell: UITableViewCell {
    private weak var howDoesItWorkButtonDelegate: IHowDoesItWorkButtonDelegate?
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 24
    
    static var reuseIdentifier: String {
        return String(describing: RenewableCell.self)
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
        stackView.alignment = .leading
        stackView.spacing = spacing
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var gramsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var greenEnergyStatusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Body.defaultFont
        label.textColor = Colours.Text.secondaryText
        return label
    }()
    
    private lazy var howDoesItWorkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        return button
    }()
    
    override func prepareForReuse() {
        greenEnergyStatusLabel.text = nil
        gramsLabel.text = nil
        super.prepareForReuse()
    }

    // MARK: - Public
    
    func update(with grams: NSAttributedString, energyType: String, buttonTitle: NSAttributedString) {
        gramsLabel.attributedText = grams
        greenEnergyStatusLabel.text = energyType
        howDoesItWorkButton.setAttributedTitle(buttonTitle, for: .normal)
    }
    
    func configureLinkButtonDelgate(with delegate: IHowDoesItWorkButtonDelegate) {
        howDoesItWorkButtonDelegate = delegate
    }
}

private extension RenewableCell {
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(gramsLabel)
        stackView.addArrangedSubview(greenEnergyStatusLabel)
        stackView.addArrangedSubview(howDoesItWorkButton)
    }
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    @objc
    func buttonDidTapped() {
        howDoesItWorkButtonDelegate?.howDoesItWorkButtoDidTapped()
    }
}
