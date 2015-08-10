//
//  ViewController.swift
//  Calculator
//
//  Created by Ankit Kumar on 5/25/15.
//  Copyright (c) 2015 Ankit Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var decimalSep: UIButton!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userTyping = false
    var brain = CalculatorBrain()
    let decimalSeparator = NSNumberFormatter().decimalSeparator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decimalSep.setTitle(decimalSeparator, forState: UIControlState.Normal)
        display.text = " "
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userTyping)
        {
        if (digit == decimalSeparator) && (display.text!.rangeOfString(decimalSeparator) != nil) { return }
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
            if (digit != decimalSeparator) && ((display.text == "0") || (display.text == "-0")) {
                if (display.text == "0") {
                    display.text = digit
                } else {
                    display.text = "-" + digit
                }
            } else {
            display.text = display.text! + digit
        }
        }
        else
        {
            if (digit == decimalSeparator){
                display.text = "0" + decimalSeparator
            }
            else{
            display.text = digit
            }
            userTyping = true
            history.text = brain.description != "?" ? brain.description : ""
        }
    }
    
    @IBAction func storeVariable(sender: UIButton) {
        if let variable = last(sender.currentTitle!){
            if displayValue != nil {
                brain.variableValues["\(variable)"] = displayValue
                displayValue = brain.evaluate()
            }
        }
        userTyping = false
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if userTyping{
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!){
            displayValue = result
        }else{
            displayValue = nil
        }
    }
   
    
    @IBAction func backspace() {
        if userTyping{
            let dispText = display.text!
            if count(dispText) > 1 {
                display.text = dropLast(dispText)
                 if (count(dispText) == 2) && (display.text?.rangeOfString("-") != nil) {
                    display.text = "-0"
                }
            }else {
                display.text = "0"
            }
            }else {
                if let result = brain.popOperand() {
                    displayValue = result
                }else {
                    displayValue = nil
            }
        }
    }


    @IBAction func clear(sender: UIButton) {
        brain = CalculatorBrain()
        history.text = ""
        displayValue = nil
    }
    
    @IBAction func enter() {
        userTyping = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!){
                displayValue = result
            }else {
                displayValue = nil
            }
        }
    }
    
    var displayValue: Double?{
        get{
            if let displayText = display.text{
                if let displayNum = NSNumberFormatter().numberFromString(displayText){
                    return displayNum.doubleValue
                }
            }
            return nil
        }
        set{
            if (newValue != nil){
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            }else{
                display.text = " "
            }
            userTyping = false
            history.text = brain.description + " ="
            
        }
    }   
    
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle{
            if(userTyping){
                if operation == "+/-"
                {
                    let displayText = display.text!
                    if (displayText.rangeOfString("-") != nil)
                    {
                        display.text = dropFirst(displayText)
                    }else {
                    display.text = "-" + displayText
                    }
                    return
                }
                enter()
            }
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else{
                displayValue = nil //really lame change displayValue for to an optional to return a nil
            }
        }        
    }
    
}