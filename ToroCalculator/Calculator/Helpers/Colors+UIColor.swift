//
//  Colors+UIColor.swift
//  Calculator
//
//  Created by Adrian Mendoza Casado on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import Foundation
import UIKit

enum Colors {
    case white
    case blue
    case black
    case orange
    
    var color: UIColor {
        switch self {
        case .white: return UIColor.white
        case .blue: return UIColor.blue
        case .black: return UIColor.black
        case .orange: return UIColor.orange
        }
    }
}
