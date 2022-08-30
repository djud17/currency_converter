//
//  CalculateViewController.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import UIKit
import DropDown

final class CalculateViewController: UIViewController {
    @IBOutlet weak var firstCurrencyDDview: UIView!
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var secondCurrencyDDview: UIView!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    @IBOutlet weak var exchangeDirectionButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var currencies: [Currrency]?
    private var firstDropDown: DropDown!
    private var secondDropDown: DropDown!
    
    private var exchangeDirection: ExchangeDirection = .forward
    private enum ExchangeDirection: String {
        case forward = "arrow.forward"
        case backward = "arrow.backward"
    }
    
    private var firstCurrencyIndex: Int?
    private var secondCurrencyIndex: Int?
    private enum CurrencyNumber {
        case first
        case second
    }
    
    private enum ErrorType {
        case noData
        case notNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Currency calculator"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        hideLabels()
        resultLabel.isHidden = true
        firstDropDown = setDropDownMenu(firstCurrencyDDview, firstCurrencyLabel, CurrencyNumber.first)
        secondDropDown = setDropDownMenu(secondCurrencyDDview, secondCurrencyLabel, CurrencyNumber.second)
    }
    
    @IBAction func selectFirstCurrency(_ sender: UIButton) {
        firstDropDown.show()
    }
    
    @IBAction func selectSecondCurrency(_ sender: UIButton) {
        secondDropDown.show()
    }
    
    @IBAction func exchangeDirectionBtnTapped(_ sender: UIButton) {
        var rotateAngle: CGFloat
        
        switch exchangeDirection {
        case .forward:
            exchangeDirection = .backward
            rotateAngle = .pi
        case .backward:
            exchangeDirection = .forward
            rotateAngle = .pi * 2
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            sender.transform = CGAffineTransform(rotationAngle: rotateAngle)
        }
    }
    
    private func setDropDownMenu(_ anchorView: UIView,_ currencyLabel: UILabel, _ currencyIndex: CurrencyNumber) -> DropDown {
        let dropDown = DropDown()
        var data = [String]()
        
        if let currencies = currencies {
            currencies.forEach { data.append($0.charCode)}
        }
        
        dropDown.dataSource = data
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height) ?? 0)
        dropDown.topOffset = CGPoint(x: 0, y:-((dropDown.anchorView?.plainView.bounds.height) ?? 0))
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.hideLabels()
            currencyLabel.text = currencies?[index].charCode
            switch currencyIndex {
            case .first:
                self.firstCurrencyIndex = index
            case .second:
                self.secondCurrencyIndex = index
            }
        }
        
        anchorView.layer.cornerRadius = 5
        anchorView.layer.borderColor = UIColor.black.cgColor
        anchorView.layer.borderWidth = 1
        dropDown.anchorView = anchorView
        
        return dropDown
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        hideLabels()
        
        if checkData() {
            let firstIndex: Int = firstCurrencyIndex ?? 0
            let secondIndex: Int = secondCurrencyIndex ?? 0
            let value: Int = Int(currencyTextField.text ?? "") ?? 0
            var firstCurrency: Currrency
            var secondCurrency: Currrency
            
            if let currencies = currencies {
                switch exchangeDirection {
                case .forward:
                    firstCurrency = currencies[firstIndex]
                    secondCurrency = currencies[secondIndex]
                case .backward:
                    firstCurrency = currencies[secondIndex]
                    secondCurrency = currencies[firstIndex]
                }
                
                let result = calculate(value, firstCurrency, secondCurrency)
                let roundResult = Double(round(100 * result) / 100)
                resultLabel.isHidden = false
                resultLabel.text = "\(value) \(firstCurrency.charCode) = \(roundResult) \(secondCurrency.charCode)"
            }
        }
    }
    
    private func checkData() -> Bool {
        var checkResult: Bool = true
        
        if firstCurrencyIndex == nil {
            showError(firstCurrencyDDview, .noData)
            checkResult = false
        }
        if secondCurrencyIndex == nil {
            showError(secondCurrencyDDview, .noData)
            checkResult = false
        }
        if currencyTextField.text == "" {
            showError(currencyTextField, .noData)
            checkResult = false
        } else {
            let text = currencyTextField.text ?? ""
            if Int(text) == nil {
                showError(currencyTextField, .notNumber)
                checkResult = false
            }
        }
        return checkResult
    }
    
    @IBAction func textFieldEditingStart(_ sender: Any) {
        hideLabels()
    }
    
    
    private func hideLabels() {
        resultLabel.isHidden = true
        errorLabel.isHidden = true
        
        for view in [firstCurrencyDDview, secondCurrencyDDview, currencyTextField] {
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.black.cgColor
            view?.layer.cornerRadius = 3
        }
    }
    
    private func showError(_ view: UIView,_ errorType: ErrorType) {
        var errorText: String
        
        switch errorType {
        case .noData:
            errorText = "Error: Missing data, try again!"
        case .notNumber:
            errorText = "Error: It is not a number, try again!"
        }
        errorLabel.isHidden = false
        errorLabel.text = errorText
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 3
    }
    
    private func calculate(_ number: Int, _ firstCurrency: Currrency, _ secondCurrency: Currrency) -> Double {
        let firstValue: Double = parseValue(firstCurrency.value)
        let secondValue: Double = parseValue(secondCurrency.value)
        
        let firstValueRub: Double = (Double(number) / (Double(firstCurrency.nominal) ?? 0)) * firstValue
        let resultValue: Double = firstValueRub / (secondValue * (Double(secondCurrency.nominal) ?? 0))
        
        return resultValue
    }
    
    private func parseValue(_ value: String) -> Double {
        var result = ""
        
        value.forEach { result += $0 == "," ? "." : String($0) }
        
        return Double(result) ?? 0
    }
}
