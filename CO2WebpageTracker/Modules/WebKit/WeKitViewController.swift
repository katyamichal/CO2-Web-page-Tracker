//
//  WebKitViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import UIKit
import WebKit

protocol IWebKitView: AnyObject {
    func makeRequest()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(message: Constants.AlerMessagesType)
}

final class WebKitViewController: UIViewController {
    private let presenter: IWebKitPresenter
    
    // MARK: - Views

    private lazy var webKitView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webKitView = WKWebView(frame: .zero, configuration: configuration)
        webKitView.navigationDelegate = self
        return webKitView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.tintColor = .red
        return indicator
    }()
    
    // MARK: - Init
    
    init(presenter: IWebKitPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        super.loadView()
        view.addSubview(webKitView)
        view.addSubview(loadingIndicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        configureNavBarButtons()
        presenter.viewDidLoaded(view: self)
        presenter.viewIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webKitView.frame = view.bounds
    }
}

extension WebKitViewController: IWebKitView {
    func makeRequest() {
        guard let request = presenter.urlRequest else { return }
        webKitView.load(request)
        presenter.viewIsLoading()
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func showError(message: Constants.AlerMessagesType) {
        let alert = UIAlertController(title: message.title, message: message.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: message.cancelButtonTitle, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - WebKit Navigation Delegate

extension WebKitViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        presenter.viewIsLoaded()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        presenter.viewIsLoaded(with: error)
    }
}

private extension WebKitViewController {
    func setupConstraints() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func configureNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.UIElementTitle.done, style: .done, target: self, action: #selector(didTapDone))
    }
    
    @objc
    func didTapDone() {
        presenter.doneButtonDidTapped()
    }
}
