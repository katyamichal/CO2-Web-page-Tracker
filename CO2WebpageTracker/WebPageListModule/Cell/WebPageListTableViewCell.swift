//
//  WebPageListTableViewCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import Foundation
import UIKit

final class WebPageListTableViewCell: UITableViewCell {
    
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 8
    private let progressViewHeight: CGFloat = 3
    
    static var reuseIdentifier: String {
        return String(describing: WebPageListTableViewCell.self)
    }
    
    var currentState: LoadingStatus = .nonActive {
        didSet {
            updateState()
        }
    }
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
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
    
    private lazy var loadedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var loadingProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.heightAnchor.constraint(equalToConstant: progressViewHeight).isActive = true
        return progressView
    }()
    
    private lazy var pauseLoadingView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Public
    
    override func prepareForReuse() {
        loadingProgressView.progress = 0.0
        loadedImage.image = nil
        pauseLoadingView.image = nil
        messageLabel.text = nil
        super.prepareForReuse()
    }
}

// MARK: - Setup methods

private extension WebPageListTableViewCell {
    func setupCell() {
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(loadingStackView)
        loadingStackView.addArrangedSubview(messageLabel)
        loadingStackView.addArrangedSubview(activityIndicator)
        loadingStackView.addArrangedSubview(pauseLoadingView)
        loadingStackView.addArrangedSubview(loadingProgressView)
        loadingStackView.addArrangedSubview(loadedImage)
    }
    
    func setupConstraints() {
        loadingStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        loadingStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        loadingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        loadingStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func updateState() {
        switch currentState {
            
        case .loading(let progress, let image):
            loadingProgressView.isHidden = false
            pauseLoadingView.isHidden = false
            pauseLoadingView.image = image
            loadingProgressView.progress = progress
            loadedImage.isHidden = true
            messageLabel.isHidden = true
            activityIndicator.stopAnimating()
            
        case .completed(let url):
            //loadedImage.image = image
           // loadedImage.isHidden = false
            loadingProgressView.isHidden = true
            pauseLoadingView.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = url
            
        case .failed(let message):
            loadingProgressView.isHidden = true
            pauseLoadingView.isHidden = true
            loadedImage.isHidden = true
            messageLabel.isHidden = false
            messageLabel.text = message
            
        case .nonActive:
            loadingProgressView.isHidden = true
            pauseLoadingView.isHidden = true
            loadedImage.isHidden = true
            messageLabel.isHidden = true
            
        case .paused(let image):
            loadingProgressView.isHidden = false
            pauseLoadingView.isHidden = false
            pauseLoadingView.image = image
            loadedImage.isHidden = true
            messageLabel.isHidden = true
            
        case .waitToLoad(let message):
            loadingProgressView.isHidden = true
            pauseLoadingView.isHidden = true
            loadedImage.isHidden = true
            messageLabel.text = message
            messageLabel.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}
