//
//  CalculatorPresenter.swift
//  Calculator
//
//  Created by MENDOZA CASADO Adrian on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import Foundation
import UIKit

final class CalculatorPresenter: CalculatorPresenterProtocol {
    
    weak var view: CalculatorViewProtocol!
    var router: CalculatorRouterProtocol!
    
    //Handles decimal Point
    private var enableDecimalPoint = true
    
    //Handles equal Label
    var isResultStatement = false {
        didSet{
            if isResultStatement == false {
                hideOrShowEqualLabel(bool: true)
            }else{
                hideOrShowEqualLabel(bool: false)
            }
        }
    }
    
    private func hideOrShowEqualLabel(bool: Bool) {
        view.equalLabel.isHidden = bool
    }
    
    //MARK: - Formatter: Change Coma For Decimal Point, usefull for some device regions
    func comaFormatter(_ string: String) {
        var lastString = string
        if lastString.contains(Constants.coma) || lastString.contains(Constants.decimal) {
            lastString = lastString.replacingOccurrences(of: Constants.coma, with: Constants.decimal)
            if lastString.first == Constants.decimal.first! {
                view.currentText = Constants.zero + lastString
            } else if lastString.hasPrefix(Constants.minusPoint){
                lastString.insert(Constants.zero.first!, at: lastString.index(lastString.startIndex, offsetBy: 1))
                view.currentText = lastString
            } else {
                view.currentText = lastString
            }
        }else {
            view.currentText = lastString
        }
    }
    
    //MARK: - Do Operation
    func doMath(string: String){
        let expression = NSExpression(format: string)
        guard let mathValue = expression.expressionValue(with: nil, context: nil) as? Double else { return }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let value = formatter.string(from: NSNumber(value: mathValue)) else { return }
        let lastValue = value
        comaFormatter(lastValue)
    }
    
    //Add Actions To Buttons
    func setupSelectors(){
        for btn in view.allCalculatorButtons {
            btn.addTarget(self, action: #selector(performOperation(_:)), for: .touchUpInside)
        }
    }

    //Actions For Buttons
    @objc private func performOperation(_ sender: CustomButton){
        let lastCurrentCharacter: String = String(view.currentText.last!)
        
        switch sender.tag {
        case 0://Number 0
            if isResultStatement != true {
                view.currentText.append(String(sender.tag))
            }
        case 1...9://Numbers 1-9
            if isResultStatement == true {
                view.currentText = String(sender.tag)
                enableDecimalPoint = true
                isResultStatement = false
            } else {
                view.currentText.append(String(sender.tag))
            }
        case 11: //Minus & Plus
            if isResultStatement == true && view.currentText != Constants.zero {
                view.currentText.append(sender.operation)
                isResultStatement = false
                enableDecimalPoint = true
            } else if isResultStatement == false && !view.lockOperations.contains(lastCurrentCharacter) {
                view.currentText.append(sender.operation)
                enableDecimalPoint = true
            }
        case 12://decimal
            if view.currentText == Constants.zero {
                view.currentText.append(sender.operation)
                isResultStatement = false
                enableDecimalPoint = false
            } else  if isResultStatement == true && view.currentText != Constants.zero {
                view.currentText = Constants.zero + Constants.decimal
                isResultStatement = false
                enableDecimalPoint = false
            } else if isResultStatement == false && !view.lockOperations.contains(lastCurrentCharacter) && enableDecimalPoint == true {
                view.currentText.append(sender.operation)
                isResultStatement = false
                enableDecimalPoint = false
            }
        case 13://equal
            if isResultStatement == false && !view.lockOperations.contains(lastCurrentCharacter) {
                doMath(string: view.currentText)
                isResultStatement = true
                enableDecimalPoint = true
            } else if view.lockOperations.contains(lastCurrentCharacter) {
                view.currentText.append(Constants.zero)
                doMath(string: view.currentText)
                isResultStatement = true
                enableDecimalPoint = true
            }
        case 14://clear
            view.currentText = Constants.zero
            isResultStatement = true
            enableDecimalPoint = true
        default:
            break
        }
    }
    
}













