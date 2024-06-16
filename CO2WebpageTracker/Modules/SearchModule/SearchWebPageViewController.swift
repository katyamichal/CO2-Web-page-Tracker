//
//  SearchWebPageViewController.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit

protocol ISearchWebPageView: AnyObject {
    func updateView(with status: SearchStatus)
    func prepareForRequest()
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
        setupSearchBar()
        setupAction()
    }
}

extension SearchWebPageViewController: ISearchWebPageView {
    func updateView(with status: SearchStatus) {
        searchView.update(with: status)
    }
    
    func prepareForRequest() {
        
    }
    
    func showAlert(with type: Constants.AlerMessagesType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        let action = UIAlertAction(title: type.buttonTitle, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

// MARK: - TextField Delegate Methods

extension SearchWebPageViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchView.searchView.searchBar.resignFirstResponder()
        guard let str = searchBar.text else {
            return
        }
        presenter.loadData(with: str)
    }
}

private extension SearchWebPageViewController {
    
    func setupAction() {
        searchView.setupActionForTryAgainButton(target: self, action: #selector(searchAgain))
    }
    
    func setupSearchBar() {
        searchView.searchView.searchBar.becomeFirstResponder()
        searchView.searchView.searchBar.delegate = self
    }
    
    func setupKeyboardBehavior() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc
    func searchAgain() {
        presenter.tryAgainButtonPressed()
    }
    
    //    @objc
    //    func keyboardHandeling(notification: NSNotification) {
    //        guard let userInfo = notification.userInfo,
    //              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
    //            return
    //        }
    //        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
    //        let adjustedContentInset: UIEdgeInsets
    //        if isKeyboardShowing {
    //            adjustedContentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    //        } else {
    //            adjustedContentInset = .zero
    //        }
    //        let animationDuration: Double = 0.2
    //        UIView.animate(withDuration: animationDuration) {
    ////            self.searchView.searchStackView.layoutMargins.bottom= adjustedContentInset
    ////            self.searchView.searchStackView.scrollIndicatorInsets = adjustedContentInset
    //        }
    //    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification, isShowing: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification, isShowing: false)
    }
    
    func adjustForKeyboard(notification: NSNotification, isShowing: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.2
        
        UIView.animate(withDuration: animationDuration) {
            if isShowing {
                self.searchView.stackViewBottomConstraint?.constant = -keyboardHeight
            } else {
                self.searchView.stackViewBottomConstraint?.constant = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
}
