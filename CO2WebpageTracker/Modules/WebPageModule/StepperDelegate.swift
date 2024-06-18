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
    
    func stepperValueChanged(_ sender: UIStepper) {
        delegate?.didChanged(with: Int(sender.value))
    }
}
