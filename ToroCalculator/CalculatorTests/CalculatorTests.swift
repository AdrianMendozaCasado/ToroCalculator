//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by MENDOZA CASADO Adrian on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    let view = CalculatorViewController()
    let presenter = CalculatorPresenter()
    
    override func setUp() {
        super.setUp()
        presenter.view = view
        presenter.isResultStatement = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdd() {
        view.currentText = "3+3"
        presenter.doMath(string: view.currentText)
        XCTAssert(view.currentText == "6")
    }
    
    func testSubstract() {
        view.currentText = "20-10"
        presenter.doMath(string: view.currentText)
        XCTAssert(view.currentText == "10")
    }
    
    func testAddAndSubstract() {
        view.currentText = "20+10-8+10"
        presenter.doMath(string: view.currentText)
        XCTAssert(view.currentText == "32")
    }
    
    func testAddAndSubstractWithDecimal() {
        view.currentText = "20.5-10.3+1"
        presenter.doMath(string: view.currentText)
        XCTAssert(view.currentText == "11.2")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
