//
//  CalculatorRouter.swift
//  Calculator
//
//  Created by Adrian Mendoza Casado on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import Foundation
import UIKit

final class CalculatorRouter: CalculatorRouterProtocol {
    
    static func assembleModule() -> UIViewController {
         let viewController = CalculatorViewController()
        if let view = viewController as? CalculatorViewController {
            let presenter = CalculatorPresenter()
            let router = CalculatorRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            
            return viewController
        }
        return UIViewController()
    }
}


