//
//  WebKitViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 30.07.2024.
//

import UIKit
import WebKit

protocol IWebKitView: AnyObject {
    
}

final class WebKitViewController: UIViewController {
    private let presenter: IWebKitPresenter
    
    private lazy var webKitView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webKitView = WKWebView(frame: .zero, configuration: configuration)
        return webKitView
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded(view: self)
        configureWebKitView()
      //  configureNavBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webKitView.frame = view.bounds
       // let navigBarYOffset = navigationController?.navigationBar.bounds.size.height
        //webKitView.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + navigBarYOffset!, width: view.bounds.size.width, height: view.bounds.size.height)
    }
}

extension WebKitViewController: IWebKitView {}

private extension WebKitViewController {
    func configureWebKitView() {
        guard let request = presenter.urlRequest else { return }
        webKitView.load(request)
    }
//    
//    func configureNavBarButtons() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
//    }
//    
//    @objc
//    func didTapDone() {
//        presenter.doneButtonDidTapped()
//    }
}

