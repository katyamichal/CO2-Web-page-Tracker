//
//  CarbonRatingCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 14.06.2024.
//

import UIKit
final class CarbonRatingCell: UITableViewCell {
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 24
    private let letterViewHeight: CGFloat = 130
    
    static var reuseIdentifier: String {
        return String(describing: CarbonRatingCell.self)
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var stackView: UIStackView = {
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
    
    private lazy var scaleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = letterViewHeight / 2
        return view
    }()
    
    private lazy var scaleLetterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Fonts.Body.largeFont
        return label
    }()
    
    private lazy var resultForLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Body.descriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Body.descriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var cleanerThanLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Body.descriptionFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var ratingView: GradientRatingView = {
        let view = GradientRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return view
    }()
    
    // leart about
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Fonts.Body.defaultFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override func prepareForReuse() {
        scaleLetterLabel.text = nil
        resultForLabel.text = nil
        descriptionLabel.text = nil
        cleanerThanLabel.text = nil
        dateLabel.text = nil
        super.prepareForReuse()
    }
    
    func update(with colour: UIColor, with letter: String, description: String, url: String, cleanerThan: String, date: String) {
        scaleView.backgroundColor = colour
        resultForLabel.text = url
        scaleLetterLabel.text = letter
        descriptionLabel.text = description
        cleanerThanLabel.text = cleanerThan
        dateLabel.text = date
    }
}

private extension CarbonRatingCell {
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(scaleView)
        scaleView.addSubview(scaleLetterLabel)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(resultForLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(ratingView)
        stackView.addArrangedSubview(cleanerThanLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    
    func setupConstraints() {
        scaleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset).isActive = true
        scaleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        scaleView.widthAnchor.constraint(equalToConstant: letterViewHeight).isActive = true
        scaleView.heightAnchor.constraint(equalToConstant: letterViewHeight).isActive = true
        
        scaleLetterLabel.centerXAnchor.constraint(equalTo: scaleView.centerXAnchor).isActive = true
        scaleLetterLabel.centerYAnchor.constraint(equalTo: scaleView.centerYAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scaleView.bottomAnchor, constant: inset).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
