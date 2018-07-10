//
//  CustomButtons.swift
//  Calculator
//
//  Created by Adrian Mendoza Casado on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    private var color: UIColor!
    var operation: String!
    
    func setupView(){
        self.backgroundColor = color
        let text = NSAttributedString(string: operation,
                                      attributes: [NSAttributedStringKey.font :  UIFont(name: Constants.avenirNextMedium, size: 40)!,
                                                   NSAttributedStringKey.foregroundColor : UIColor.black])
        self.setAttributedTitle(text, for: .normal)
        self.layer.cornerRadius = 2
    }
    
    required init(operation: String, color: UIColor = .white, tag: Int) {
        super.init(frame: .zero)
        self.color = color
        self.operation = operation
        self.tag = tag
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
