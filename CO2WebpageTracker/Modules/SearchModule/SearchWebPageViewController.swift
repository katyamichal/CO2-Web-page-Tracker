//
//  SearchWebPageViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

protocol ISearchWebPageView: AnyObject {
    func updateView(with status: SearchStatus)
    func showAlert(with type: Constants.AlerMessagesType)
}

final  class SearchWebPageViewController: UIViewController {
    
    private var searchView: WebPageSearchView { return self.view as! WebPageSearchView }
    private let presenter: ISearchWebPagePresenter
    
    // MARK: - Inits
    
    init(presenter: ISearchWebPagePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Cycle
    
    override func loadView() {
        view = WebPageSearchView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded(view: self)
        setupKeyboardBehavior()
        setupSearchTextField()
        setupActions()
    }
}

extension SearchWebPageViewController: ISearchWebPageView {
    func updateView(with status: SearchStatus) {
        searchView.update(with: status)
    }
#warning("[weak self]????")
    func showAlert(with type: Constants.AlerMessagesType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let action = UIAlertAction(title: type.cancelButtonTitle, style: .cancel) {_ in
            self.searchView.searchView.searchTextField.becomeFirstResponder()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

// MARK: - Search TextField Delegate Methods

extension SearchWebPageViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.enablesReturnKeyAutomatically = false
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchView.searchView.searchTextField.resignFirstResponder()
        guard let str = textField.text else {
            return false
        }
        if presenter.prepareToLoad(with: str) {
            presenter.loadData(with: str)
            return true
        } else {
            return false
        }
    }
}


private extension SearchWebPageViewController {
    func setupActions() {
        setupTryAgainAction()
        setupCalculateAction()
        setupPauseLoaingButton()
    }
    
    func setupTryAgainAction() {
        searchView.setupActionForTryAgainButton(target: self, action: #selector(searchAgain))
    }
    
    func setupCalculateAction() {
        searchView.setupActionForCalculateButton(target: self, action: #selector(calculate))
    }
    
    func setupPauseLoaingButton() {
        searchView.setupActionForPauseButton(target: self, action: #selector(pauseLoading))
    }
    
    func setupSearchTextField() {
        searchView.searchView.searchTextField.becomeFirstResponder()
        searchView.searchView.searchTextField.delegate = self
    }
    
    @objc
    func searchAgain() {
        presenter.tryAgainButtonPressed()
    }
    
    @objc
    func calculate() {
        searchView.searchView.searchTextField.resignFirstResponder()
        let str = searchView.searchView.searchTextField.text
        guard let str else {
            return
        }
        print(str)
        if presenter.prepareToLoad(with: str) {
            presenter.loadData(with: str)
        }
    }
    
    @objc
    func pauseLoading() {
        presenter.changeLoadingStatus()
    }
    
    func setupKeyboardBehavior() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandling), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandling), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardHandling(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        let adjustedContentInset: UIEdgeInsets
        if isKeyboardShowing {
            adjustedContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        } else {
            adjustedContentInset = .zero
        }
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        UIView.animate(withDuration: animationDuration) {
//            self.searchView.searchStackView.contentInset = adjustedContentInset
//            self.searchView.searchStackView.scrollIndicatorInsets = adjustedContentInset
        }
    }
}
