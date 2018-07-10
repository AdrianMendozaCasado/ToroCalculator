//
//  CalculatorProtocols.swift
//  Calculator
//
//  Created by MENDOZA CASADO Adrian on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import Foundation
import UIKit

protocol CalculatorViewProtocol: class {

    var presenter: CalculatorPresenterProtocol! { get set }
    var currentText: String { get set }
    var equalLabel: UILabel { get set }
    var lockOperations: [String] { get set }
    var allCalculatorButtons: [CustomButton] { get set }
}

protocol CalculatorPresenterProtocol: class {

    var view: CalculatorViewProtocol! { get set }
    var router: CalculatorRouterProtocol! { get set }
    
    var isResultStatement: Bool { get set }
    
    func setupSelectors()
}

protocol CalculatorRouterProtocol: class {
   
    static func assembleModule() -> UIViewController
}
