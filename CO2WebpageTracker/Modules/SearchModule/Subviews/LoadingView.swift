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
    private let buttonCornerRadius: CGFloat = 5
    private let pauseLoadingButtonFontSize: CGFloat = 40
    
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
        stackView.alignment = .center
        stackView.spacing = spacing
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = Colours.WebPageColours.darkOrange
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var pauseLoadingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Colours.WebPageColours.darkOrange
        button.contentMode = .scaleAspectFit
        let font = UIFont.systemFont(ofSize: pauseLoadingButtonFontSize)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let unselectedImage = UIImage(systemName: Constants.UIElementSystemNames.pausedImage, withConfiguration: configuration)
        let selectedImage = UIImage(systemName: Constants.UIElementSystemNames.activeImage, withConfiguration: configuration)
        button.setImage(unselectedImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        return button
    }()
    
    private lazy var cancelLoadingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.UIElementNames.cancelButton, for: .normal)
        button.backgroundColor = Colours.Button.black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = buttonCornerRadius
        return button
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = Fonts.Titles.mainTitle
        label.textColor = Colours.Text.secondaryText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.Titles.subtitle
        button.setTitle(Constants.SearchLoadingMessage.testAgain, for: .normal)
        button.backgroundColor = Colours.Button.black
        button.layer.cornerRadius = buttonCornerRadius
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        return button
    }()
    
    // MARK: - Public - Setup methods for subviews' buttons
    
    func setupActionForTryAgainButton(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        tryAgainButton.addTarget(target, action: action, for: event)
    }
    
    func setupActionForPauseButton(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        pauseLoadingButton.addTarget(target, action: action, for: event)
    }
    
    func setupActionForCancelLoadingButton(target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) {
        cancelLoadingButton.addTarget(target, action: action, for: event)
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
        loadingStackView.addArrangedSubview(pauseLoadingButton)
        loadingStackView.addArrangedSubview(activityIndicator)
        loadingStackView.addArrangedSubview(tryAgainButton)
        loadingStackView.addArrangedSubview(cancelLoadingButton)
    }
    
    func setupConstraints() {
        loadingStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadingStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loadingStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        loadingStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cancelLoadingButton.widthAnchor.constraint(equalTo: loadingStackView.widthAnchor, multiplier: 0.6).isActive = true
        tryAgainButton.widthAnchor.constraint(equalTo: loadingStackView.widthAnchor, multiplier: 0.6).isActive = true
        
    }
    
    private func updateState() {
        switch currentState {
            
        case .loading(let message):
            activityIndicator.startAnimating()
            messageLabel.isHidden = false
            messageLabel.text = message
            pauseLoadingButton.isHidden = false
            pauseLoadingButton.isHidden = false
            tryAgainButton.isHidden = true
            pauseLoadingButton.isSelected = false
            cancelLoadingButton.isHidden = false
            
        case .completed(let url):
            pauseLoadingButton.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = url
            tryAgainButton.isHidden = true
            cancelLoadingButton.isHidden = true
            activityIndicator.stopAnimating()
            
        case .failed(let message):
            pauseLoadingButton.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message
            activityIndicator.stopAnimating()
            cancelLoadingButton.isHidden = true
            tryAgainButton.isHidden = false
            
        case .nonActive:
            pauseLoadingButton.isHidden = true
            messageLabel.isHidden = true
            tryAgainButton.isHidden = true
            cancelLoadingButton.isHidden = true
            
        case .paused:
            pauseLoadingButton.isHidden = false
            pauseLoadingButton.isSelected = true
            messageLabel.isHidden = false
            cancelLoadingButton.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
}
