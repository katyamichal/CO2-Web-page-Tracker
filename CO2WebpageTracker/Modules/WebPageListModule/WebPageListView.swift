//
//  WebPageView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 13.06.2024.
//

import UIKit

final class WebPageListView: UIView {
    
    private let inset: CGFloat = 8
    private let searchFieldHeight: CGFloat = 40
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Element
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(WebPageListTableViewCell.self, forCellReuseIdentifier: WebPageListTableViewCell.reuseIdentifier)
        return tableView
    }()
}

private extension WebPageListView {
    func setupView() {
        backgroundColor = Colours.WebPageColours.khaki
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

}

#warning("Bug to solve")
/// Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window. Table view: <UITableView: 0x11206bc00; frame = (0 157.667; 393 611.333); clipsToBounds = YES; gestureRecognizers = <NSArray: 0x600000ce56b0>; backgroundColor = UIExtendedGrayColorSpace 0 0; layer = <CALayer: 0x6000002eed00>; contentOffset: {0, 0}; contentSize: {393, 103.33333333333333}; adjustedContentInset: {0, 0, 0, 0}; dataSource: <CO2WebpageTracker.WebPageListViewController: 0x10b704830>>
