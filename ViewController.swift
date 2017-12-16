//
//  ViewController.swift
//  currencyconverter
//
//  Created by YUMI KIM on 2017. 12. 4..
//  Copyright © 2017년 YUMI KIM. All rights reserved.
//

import UIKit

let decimalSeparator = "."

class ViewController: UIViewController {
    
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var fromValueLabel: UILabel!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var decimalSeparatorButton: UIButton!
    @IBOutlet weak var cursorView: UIView!
    
    private var fromValueString = "0"
    private var cursorTimer: Timer!
    private var blinkStatus = true
    
    private var fromCurrency = Currency(name: "KRW", rateToUsd: 1)
    private var toCurrency = Currency(name: "USD", rateToUsd: 0.001)
    
     @IBOutlet weak var Button: UIButton!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         decimalSeparatorButton.setTitle(decimalSeparator, for: .normal)
        startCursorBlinking()
        // Do any additional setup after loading the view, typically from a nib.
        Button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fromCurrency = CurrencyExchange.shared.fromCurrency
        self.toCurrency = CurrencyExchange.shared.toCurrency
        onCurrencyChanged()
    }
    
    func startCursorBlinking() {
        cursorTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(blink), userInfo: nil, repeats: true)
        RunLoop.current.add(cursorTimer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func blink () {
        if blinkStatus == false {
            cursorView.backgroundColor = UIColor.clear
            blinkStatus = true
        } else {
            cursorView.backgroundColor = UIColor.black
            blinkStatus = false
        }
    }
    
    func setToCurrencyLabel(amount: Double) {
        let amountStr = String(format: "%.2f", amount)
        toCurrencyLabel.text = "\(amountStr)"
        //toCurrencyLabel.text = "\(amountStr) \(toCurrency.name)"
    }
    
    
    func updateValue(fromValueString: String) {
        fromValueLabel.text = fromValueString
        let fromValue = Double(fromValueString) ?? 0
        let toValue = convert(amount: fromValue, from: fromCurrency, to: toCurrency)
        setToCurrencyLabel(amount: toValue)
    }
    
    func onNumberButtonTapped(number: Int) {
        if fromValueString == "0" {
            fromValueString = ""
        }
        fromValueString = "\(fromValueString)\(number)"
        updateValue(fromValueString: fromValueString)
    }
    
    @IBAction func toCurrencyTapped(_ sender: Any) {
    }
    
    @IBAction func fromCurrencyTapped(_ sender: Any) {
    }
    
    @IBAction func reverseCurrency(_ sender: Any) {
        let tempCurrency = fromCurrency
        fromCurrency = toCurrency
        toCurrency = tempCurrency
        onCurrencyChanged()
        
    }
    
    func onCurrencyChanged() {
        saveSelectedCurrencies(from: fromCurrency, to: toCurrency)
        fromCurrencyButton.setTitle(fromCurrency.name, for: .normal)
        toCurrencyButton.setTitle(toCurrency.name, for: .normal)
        //updateValue(fromValueString: fromValueString)
    }

    @IBAction func buttonTapped0(_ sender: Any) {
        onNumberButtonTapped(number: 0)
    }
    @IBAction func buttonTapped1(_ sender: Any) {
        onNumberButtonTapped(number: 1)
    }
    @IBAction func buttonTapped2(_ sender: Any) {
        onNumberButtonTapped(number: 2)
    }
    @IBAction func buttonTapped3(_ sender: Any) {
        onNumberButtonTapped(number: 3)
    }
    @IBAction func buttonTapped4(_ sender: Any) {
        onNumberButtonTapped(number: 4)
    }
    @IBAction func buttonTapped5(_ sender: Any) {
        onNumberButtonTapped(number: 5)
    }
    @IBAction func buttonTapped6(_ sender: Any) {
        onNumberButtonTapped(number: 6)
    }
    @IBAction func buttonTapped7(_ sender: Any) {
        onNumberButtonTapped(number: 7)
    }
    @IBAction func buttonTapped8(_ sender: Any) {
        onNumberButtonTapped(number: 8)
    }
    @IBAction func buttonTapped9(_ sender: Any) {
        onNumberButtonTapped(number: 9)
    }
    @IBAction func buttonTappedSeparator(_ sender: Any) {
        guard !fromValueString.contains(decimalSeparator) else {
            return
        }
        fromValueString = "\(fromValueString)\(decimalSeparator)"
        updateValue(fromValueString: fromValueString)
    }
    @IBAction func buttonTappedBackspace(_ sender: Any) {
        fromValueString = String(fromValueString.dropLast())
        if fromValueString == "" {
            fromValueString = "0"
        }
        updateValue(fromValueString: fromValueString)
    }
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? ChooseCurrencyViewController {
            if segue.identifier == "toCurrencySegue" {
                destVC.isChangingFromCurrency = false
            } else {
                destVC.isChangingFromCurrency = true
            }
            destVC.inSegueIdentifier = segue.identifier ?? ""
        }
    }
    
   

}

