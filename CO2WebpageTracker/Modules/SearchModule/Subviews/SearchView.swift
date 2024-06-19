//
//  SearchView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class SearchView: UIView {
    private let inset: CGFloat = 8
    private let searchFieldHeight: CGFloat = 40
    private let spacing: CGFloat = 32
    private let buttonHeight: CGFloat = 50
    private let searchTextFieldHeight: CGFloat = 50
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIElement
    private lazy var searchStackView: UIStackView = {
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
    
    private lazy var label1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = Constants.LabelPlaceHolders.searchLabel1
        label.font = Fonts.Titles.mainTitle
        label.textAlignment = .left
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = Fonts.Titles.subtitle
        label.text = Constants.LabelPlaceHolders.searchLabel2
        label.textAlignment = .left
        return label
    }()
    
    lazy var searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: Fonts.Body.defaultFont
        ]
        let attributedPlaceholder = NSAttributedString(string: Constants.PlaceholderStrings.searchBarPlaceholder, attributes: placeholderAttributes)
        searchTextField.attributedPlaceholder = attributedPlaceholder
        searchTextField.autocapitalizationType = .none
        searchTextField.autocorrectionType = .no
        searchTextField.defaultTextAttributes = [
            NSAttributedString.Key.font: Fonts.Body.defaultFont,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        searchTextField.borderStyle = .bezel
        searchTextField.tintColor = .white
        searchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight).isActive = true
        return searchTextField
    }()
    
    private lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.tertiarySystemBackground, for: .normal)
        button.titleLabel?.font = Fonts.Buttons.primaryButtonFont
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.setTitle("Calculate", for: .normal)
        button.backgroundColor = Colours.WebPageColours.green
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Public - Setup method for Calculate Button
    
    func setupActionForCalculateButton(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        calculateButton.addTarget(target, action: action, for: event)
    }
}

private extension SearchView {
    func setupView() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(searchStackView)
        searchStackView.addArrangedSubview(label1)
        searchStackView.addArrangedSubview(label2)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(calculateButton)
    }
    
    func setupConstraints() {
        searchStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        searchStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -inset).isActive = true
        searchStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset).isActive = true
        searchStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -inset).isActive = true
        
    
    }
}
