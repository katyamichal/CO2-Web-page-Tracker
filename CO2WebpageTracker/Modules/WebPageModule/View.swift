//
//  GradientRatingView.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 18.06.2024.
//

import UIKit

final class GradientRatingView: UIView {
    
    init(with frame: CGRect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width - 20, height: 40))) {
        super.init(frame: frame)
        setupGradient()
        setupLabels()
        setupMarker()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupGradient()
//        setupLabels()
//        setupMarker()
//    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    private func setupGradient() {
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
    
    private func setupLabels() {
        let labels = ["A+", "A", "B", "C", "D", "E", "F"]
        let labelCount = labels.count
        let labelWidth = self.bounds.width / CGFloat(labelCount)
        
        for (index, labelText) in labels.enumerated() {
            let label = UILabel()
            label.text = labelText
            label.textAlignment = .center
            label.frame = CGRect(x: CGFloat(index) * labelWidth, y: 0, width: labelWidth, height: self.bounds.height)
            self.addSubview(label)
        }
    }
    
    private func setupMarker() {
        let marker = UIImageView(image: UIImage(systemName: "globe"))
        marker.tintColor = .blue
        marker.frame = CGRect(x: self.bounds.width * 0.75, y: 0, width: 30, height: 30)
        self.addSubview(marker)
    }
}

