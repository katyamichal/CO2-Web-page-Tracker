//
//  StepperDelegate.swift
//  CO2WebpageTracker
//
//  Created by Catarina Polakowsky on 18.06.2024.
//

import UIKit

protocol IStepperDelegate: AnyObject {
    func didChanged(with value: Int)
}

final class StepperDelegate: UIStepperViewDelegate {
    weak var delegate: IStepperDelegate?
    private var previousValue: Int = 1
    
    func stepperValueChanged(_ sender: UIStepper) {
        var value: Int

        if sender.value < sender.maximumValue && Int(sender.value) > previousValue {
            value = Int(sender.value - 1) * 10
        } else {
            value = Int(sender.value + 1) / 10
        }
          delegate?.didChanged(with: value)
          previousValue = value
    }
}
