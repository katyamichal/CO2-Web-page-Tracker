//
//  SearchView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class WebPageSearchView: UIView {
    private let inset: CGFloat = 8
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
     lazy var searchStackView: UIStackView = {
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
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
     lazy var searchView: SearchView = {
        let view = SearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Public methods

    func setupActionForTryAgainButton(target: Any?, action: Selector) {
        loadingView.setupActionForTryAgainButton(target: target, action: action)
    }
    
    func setupActionForCalculateButton(target: Any?, action: Selector) {
        searchView.setupActionForCalculateButton(target: target, action: action)
    }
    
    func update(with status: SearchStatus) {
        switch status {
        case .load(let loadingStatus):
            searchView.isHidden = true
            loadingView.isHidden = false
            loadingView.currentState = loadingStatus
        case .search:
            searchView.isHidden = false
            loadingView.isHidden = true
        }
    }
}

private extension WebPageSearchView {
    func setupView() {
        backgroundColor = Colours.WebPageColours.blue
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(searchStackView)
        searchStackView.addArrangedSubview(loadingView)
        searchStackView.addArrangedSubview(searchView)
    }
    
    func setupConstraints() {
        
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        searchStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        searchStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        searchStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: inset).isActive = true
    }
}
