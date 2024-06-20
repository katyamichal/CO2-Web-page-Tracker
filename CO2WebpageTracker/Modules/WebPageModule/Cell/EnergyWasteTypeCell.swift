//
//  EnergyTypeCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 16.06.2024.
//

import UIKit

protocol UIStepperViewDelegate: AnyObject {
    func stepperValueChanged(_ sender: UIStepper)
}

final class EnergyWasteTypeCell: UITableViewCell {
    
    private weak var stepperDelegate: UIStepperViewDelegate?
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 24
    
    static var reuseIdentifier: String {
        return String(describing: EnergyWasteTypeCell.self)
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
    
    private lazy var helperLabel1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Over a year, with"
        label.font = Fonts.Body.defaultFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var stepperValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Body.defaultFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        stepper.maximumValue = 1000
        stepper.addTarget(self, action: #selector(stepperVulaeDidChange), for: .valueChanged)
        return stepper
    }()
    
    private lazy var helperLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "monthly page views, this page produces"
        label.font = Fonts.Body.defaultFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var energyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Fonts.Body.defaultFont
        label.textColor = .white
        return label
    }()
    
    func configureStepperDelgate(with delegate: UIStepperViewDelegate) {
        stepperDelegate = delegate
    }
    
    
    override func prepareForReuse() {
        energyLabel.text = nil
        super.prepareForReuse()
    }
    
    // MARK: - Public
    
    func update(with energy: String, stepperValue: Int) {
        stepperValueLabel.text = "\(stepperValue)"
        stepper.value = Double(stepperValue)
        energyLabel.text = energy + " " + "of CO2 equivalent"
    }
}

private extension EnergyWasteTypeCell {
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(helperLabel1)
        stackView.addArrangedSubview(stepperValueLabel)
        stackView.addArrangedSubview(stepper)
        stackView.addArrangedSubview(helperLabel2)
        stackView.addArrangedSubview(energyLabel)
        
    }
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    @objc
    func stepperVulaeDidChange(_ sender: UIStepper) {
        stepperDelegate?.stepperValueChanged(sender)
    }
}
