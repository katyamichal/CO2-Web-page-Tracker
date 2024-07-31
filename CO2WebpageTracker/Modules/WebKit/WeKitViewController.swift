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
}

final class WebKitViewController: UIViewController {
    private let presenter: IWebKitPresenter
    
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

    // MARK: - Intitializer

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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webKitView.frame = view.bounds
    }
    private func setupConstraints() {
       // webKitView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            webKitView.topAnchor.constraint(equalTo: view.topAnchor),
//            webKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension WebKitViewController: IWebKitView {
    func makeRequest() {
        guard let request = presenter.urlRequest else { return }
        webKitView.load(request)
    }
   
    func configureNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
    }
    
    @objc
    func didTapDone() {
        presenter.doneButtonDidTapped()
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


// MARK: - WKNavigationDelegate
extension WebKitViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoadingIndicator()
        showError(message: error.localizedDescription)
    }
}
