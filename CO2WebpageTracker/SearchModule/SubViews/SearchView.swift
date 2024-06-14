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
    private let spacing: CGFloat = 16
    
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
        label.textAlignment = .left
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = Constants.LabelPlaceHolders.searchLabel2
        label.textAlignment = .left
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = Constants.PlaceholderStrings.searchBarPlaceholder
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                 textField.autocapitalizationType = .none
                 textField.autocorrectionType = .no
                 textField.text = textField.text?.lowercased()
                 textField.defaultTextAttributes = [
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                     NSAttributedString.Key.foregroundColor: UIColor.black
                 ]
             }
        return searchBar
    }()
}

private extension SearchView {
    func setupView() {
        backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(searchStackView)
        searchStackView.addArrangedSubview(label1)
        searchStackView.addArrangedSubview(label2)
        searchStackView.addArrangedSubview(searchBar)
    }
    
    func setupConstraints() {
        searchStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        searchStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -inset).isActive = true
        searchStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: inset).isActive = true
       // searchStackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
}
