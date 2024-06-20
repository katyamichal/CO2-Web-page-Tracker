//
//  ImageCell.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 20.06.2024.
//


import UIKit
final class ImageCell: UITableViewCell {
    private let spacing: CGFloat = 16
    private let inset: CGFloat = 24
    private let imageHeight: CGFloat = 300
    
    static var reuseIdentifier: String {
        return String(describing: ImageCell.self)
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
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Fonts.Titles.mainTitle
        label.textColor = .white
        return label
    }()
    private lazy var webPageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func prepareForReuse() {
        webPageImage.image = nil
        super.prepareForReuse()
    }
    
    func update(with urlTitle: String, and image: UIImage) {
        titleLabel.text = urlTitle
        webPageImage.image = image
        
    }
}

private extension ImageCell {
    func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(webPageImage)
    }
    
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        webPageImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        webPageImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset).isActive = true
        webPageImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset).isActive = true
        webPageImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        webPageImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
    }
}

