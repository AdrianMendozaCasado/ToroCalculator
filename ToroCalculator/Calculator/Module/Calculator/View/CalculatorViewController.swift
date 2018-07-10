//
//  ViewController.swift
//  Calculator
//
//  Created by MENDOZA CASADO Adrian on 26/6/18.
//  Copyright © 2018 MENDOZA CASADO Adrian. All rights reserved.
//

import UIKit
import SnapKit

final class CalculatorViewController: UIViewController, CalculatorViewProtocol {
    
    var presenter: CalculatorPresenterProtocol!
    
    //Views
    private var safeArea: UILayoutGuide!
    private lazy var displayView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var buttonsView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    //Labels
    private lazy var resultLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: Constants.futuraBold, size: 40)
        l.textColor = Colors.white.color
        l.textAlignment = .right
        return l
    }()
    
    lazy var equalLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont(name: Constants.futuraBold, size: 40)
        l.textColor = Colors.white.color
        l.textAlignment = .center
        l.text = Constants.equal
        return l
    }()
    
    //MARK: - Current Text In Result Label
    var currentText = Constants.zero {
        didSet {
            resultLabel.text = currentText
            
            if currentText.isEmpty {
                resultLabel.text = Constants.zero
                currentText = Constants.zero
            }
            if currentText.count >= 12 {
                currentText = Constants.zero
                resultLabel.text = Constants.zero
                presenter.isResultStatement = true
            }
        }
    }
    
    //MARK: Create Buttons
    private let zeroBtn = CustomButton(operation: Constants.zero, tag: 0)
    private let minusBtn = CustomButton(operation: Constants.minus, color: Colors.orange.color, tag: 11)
    private let plusBtn = CustomButton(operation: Constants.plus, color: Colors.orange.color, tag: 11)
    private let decimalBtn = CustomButton(operation: Constants.decimal, tag: 12)
    private var equalBtn = CustomButton(operation: Constants.equal, color: Colors.orange.color, tag: 13)
    private let cancelBtn = CustomButton(operation: Constants.clear, color: Colors.blue.color, tag: 14)
    
    private lazy var numberBtns: [CustomButton] = {
        let buttons = self.createNumberButtons(numbers: [1,2,3,4,5,6,7,8,9])
        return buttons
    }()
    
    //Button Array
    lazy var allCalculatorButtons: [CustomButton] = {
        var buttons = [self.decimalBtn,
                       self.equalBtn,
                       self.zeroBtn,
                       self.plusBtn,
                       self.minusBtn,
                       self.cancelBtn
        ]
        for btn in self.numberBtns {
            buttons.append(btn)
        }
        return buttons
    }()
    
    var lockOperations = [Constants.decimal, Constants.plus, Constants.minus]
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpButtons()
        setupLabelsOnDisplayView()
        presenter.setupSelectors()
        presenter.isResultStatement = true
    }
    
    //MARK: - SetUp Views Buttons And Labels
    private func setUpButtons() {
        buttonsView.addSubview(zeroBtn)
        zeroBtn.snp.makeConstraints{ make in
            make.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        buttonsView.addSubview(decimalBtn)
        decimalBtn.snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(zeroBtn)
        }
        
        buttonsView.addSubview(equalBtn)
        equalBtn.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        // Column One
        buttonsView.addSubview(numberBtns[0])
        numberBtns[0].snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(decimalBtn.snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        buttonsView.addSubview(numberBtns[3])
        numberBtns[3].snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(numberBtns[0].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        buttonsView.addSubview(numberBtns[6])
        numberBtns[6].snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.bottom.equalTo(numberBtns[3].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        // Column Two
        buttonsView.addSubview(numberBtns[1])
        numberBtns[1].snp.makeConstraints{ make in
            make.right.equalTo(zeroBtn.snp.right)
            make.bottom.equalTo(decimalBtn.snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        buttonsView.addSubview(numberBtns[4])
        numberBtns[4].snp.makeConstraints{ make in
            make.right.equalTo(zeroBtn.snp.right)
            make.bottom.equalTo(numberBtns[1].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        buttonsView.addSubview(numberBtns[7])
        numberBtns[7].snp.makeConstraints{ make in
            make.right.equalTo(zeroBtn.snp.right)
            make.bottom.equalTo(numberBtns[4].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        //Column Three
        buttonsView.addSubview(numberBtns[2])
        numberBtns[2].snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(decimalBtn.snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        buttonsView.addSubview(numberBtns[5])
        numberBtns[5].snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(numberBtns[2].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        buttonsView.addSubview(numberBtns[8])
        numberBtns[8].snp.makeConstraints{ make in
            make.left.equalTo(zeroBtn.snp.right).offset(2)
            make.bottom.equalTo(numberBtns[5].snp.top).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
        }
        
        // Column Four
        buttonsView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(equalBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        buttonsView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints{ make in
            make.bottom.equalTo(plusBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        buttonsView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalTo(minusBtn.snp.top).offset(-2)
            make.left.equalTo(decimalBtn.snp.right).offset(2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        //Toro Logo
        let titleTopImageView = UIImageView()
        let toroImage = UIImage(named: "Toro")
        titleTopImageView.contentMode = .scaleAspectFit
        titleTopImageView.image = toroImage
        titleTopImageView.backgroundColor = .clear
        buttonsView.addSubview(titleTopImageView)
        titleTopImageView.snp.makeConstraints { make in
            make.bottom.equalTo(numberBtns[7].snp.top).offset(-2)
            make.left.equalToSuperview().offset(-2)
            make.height.equalToSuperview().multipliedBy(0.2).offset(-2)
            make.width.equalToSuperview().multipliedBy(1).offset(-2)
        }
        
        
    }
    
    private func createNumberButtons(numbers: [Int]) -> [CustomButton] {
        var buttons = [CustomButton]()
        for number in numbers {
            buttons.append(CustomButton(operation: "\(number)", tag: number))
        }
        return buttons
    }
    
    
    private func setUpViews() {
        view.backgroundColor = Colors.black.color
        safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(displayView)
        displayView.snp.makeConstraints{ make in
            make.top.equalTo(safeArea.snp.top)
            make.left.right.equalTo(safeArea)
            make.height.equalTo(safeArea).multipliedBy(0.2)
        }
        
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints{ make in
            make.top.equalTo(displayView.snp.bottom)
            make.left.right.equalTo(safeArea)
            make.height.equalTo(safeArea).multipliedBy(0.8)
        }
    }
    
    private func setupLabelsOnDisplayView(){
        displayView.addSubview(equalLabel)
        equalLabel.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        displayView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints{ make in
            make.right.equalToSuperview().inset(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.bottom.equalToSuperview().offset(-40)
            make.left.equalTo(equalLabel.snp.right)
        }
        resultLabel.text = currentText
    }
}


