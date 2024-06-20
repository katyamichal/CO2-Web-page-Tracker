//
//  GradientRatingView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 18.06.2024.
//

import UIKit

final class GradientRatingView: UIView {
    
    init(with frame: CGRect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width - 40, height: 40))) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension GradientRatingView {
    func setupView() {
        setupGradient()
        setupLabels()
        setupMarker()
        setupAverageLabel()
    }
    
    func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.cornerRadius = 20
    }
    
    func setupLabels() {
        let labels = ["A+", "A", "B", "C", "D", "E", "F"]
        let labelCount = labels.count
        let labelWidth = self.bounds.width / CGFloat(labelCount)
        labels.enumerated().map { (index, labelText) in
            let label = UILabel()
            label.text = labelText
            label.textAlignment = .center
            label.frame = CGRect(x: CGFloat(index) * labelWidth, y: 0, width: labelWidth, height: self.bounds.height)
            self.addSubview(label)
        }
    }
    
    func setupMarker() {
        let marker = UIImageView(image: UIImage(systemName: Constants.UIElementSystemNames.globe))
        marker.tintColor = .systemBackground
        marker.frame = CGRect(x: self.bounds.width * 0.75, y: self.bounds.height + 10, width: 30, height: 30)
        self.addSubview(marker)
    }
    
    func setupAverageLabel() {
        let label = UILabel()
        let labelWidth = self.bounds.width / 0.4
        label.frame = CGRect(x: self.bounds.width * 0.4, y: self.bounds.height + 30, width: labelWidth, height: 30)
        label.text = "Global Average"
        label.numberOfLines = 0
        label.font = UIFont(name: "Bradley Hand", size: 19)
        label.textColor = .white
        self.addSubview(label)
    }
}



