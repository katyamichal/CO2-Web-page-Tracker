//
//  LoadingView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

final class LoadingView: UIView {
    
    private let spacing: CGFloat = 32
    private let inset: CGFloat = 8
    private let buttonHeight: CGFloat = 50
    
    var currentState: LoadingStatus = .nonActive {
        didSet {
            updateState()
        }
    }
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var loadingStackView: UIStackView = {
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var pauseLosdingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        let font = UIFont.systemFont(ofSize: 40)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let unselectedImage = UIImage(systemName: Constants.UIElementSystemNames.pausedImage, withConfiguration: configuration)
        let selectedImage = UIImage(systemName: Constants.UIElementSystemNames.activeImage, withConfiguration: configuration)
        button.setImage(unselectedImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = Fonts.Titles.mainTitle
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.tertiarySystemBackground, for: .normal)
        button.titleLabel?.font = Fonts.Buttons.primaryButtonFont
        button.setTitle("Try testing again", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = buttonHeight / 2
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        return button
    }()
    
    // MARK: - Public - Setup method for Try Again Button
    
    func setupActionForTryAgainButton(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        tryAgainButton.addTarget(target, action: action, for: event)
    }
    
    func setupActionForPauseButton(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        pauseLosdingButton.addTarget(target, action: action, for: event)
    }
}

// MARK: - Setup methods

private extension LoadingView {
    func setupView() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(loadingStackView)
        loadingStackView.addArrangedSubview(messageLabel)
        loadingStackView.addArrangedSubview(pauseLosdingButton)
        loadingStackView.addArrangedSubview(activityIndicator)
        loadingStackView.addArrangedSubview(tryAgainButton)
    }
    
    func setupConstraints() {
        loadingStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadingStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loadingStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        loadingStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func updateState() {
        switch currentState {
        
        case .loading(let message):
            activityIndicator.startAnimating()
            messageLabel.isHidden = false
            messageLabel.text = message
            pauseLosdingButton.isHidden = false
            pauseLosdingButton.isHidden = false
            tryAgainButton.isHidden = true
            pauseLosdingButton.isSelected = false
            
        case .completed(let url):
            pauseLosdingButton.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = url
            tryAgainButton.isHidden = true
            activityIndicator.stopAnimating()
            
        case .failed(let message):
            pauseLosdingButton.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message
            activityIndicator.stopAnimating()
            tryAgainButton.isHidden = false
            
        case .nonActive:
            pauseLosdingButton.isHidden = true
            messageLabel.isHidden = true
            tryAgainButton.isHidden = true
            
        case .paused:
            pauseLosdingButton.isHidden = false
            pauseLosdingButton.isSelected = true
            messageLabel.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
}
