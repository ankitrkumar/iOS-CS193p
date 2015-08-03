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
    
    let decimalSeperator = NSNumberFormatter().decimalSeparator!
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userTyping)
        {
            if(digit == decimalSeperator) && (display.text!.rangeOfString(decimalSeperator) != nil){
            return
            }
            display.text = display.text! + digit
        }
        else
        {
            if (digit == decimalSeperator){
                display.text = "0" + decimalSeperator
            }
            else{
            display.text = digit
            userTyping = true
            }
        }
        history.text = brain.description != "?" ? brain.description : ""
    }
    
    @IBAction func backspace() {
        if userTyping{
            let dispText = display.text!
            if count(dispText) > 1 {
                display.text = dropLast(dispText)
            }
            else
            {
                display.text = "0"
            }
        }
    }
    @IBAction func clear(sender: UIButton) {
        brain.clearAll()
        history.text = ""
        display.text = "0"
    }
    
    @IBAction func enter() {
        userTyping = false
        if displayValue != nil {
        if let result = brain.pushOperand(displayValue!){
            displayValue = result
        }
        else{
            displayValue = nil //really lame change displayValue for to an optional to return a nil
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
                display.text = "0"
            }
            userTyping = false
            history.text = brain.showHistory()
            
        }
    }	
    
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle{
            if(userTyping){
                if operation == "+/-"
                {
                    let displayText = display.text!
                    if (displayText.rangeOfString("=") != nil)
                    {
                        display.text = dropFirst(displayText)
                    }
                    else{
                    display.text = "-" + displayText
                    }
                    return
                }
                enter()
            }
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            
            }
            else{
                displayValue = nil //really lame change displayValue for to an optional to return a nil
            }
        }
        history.text = history.text! + "="
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decimalSep.setTitle(decimalSeperator, forState: UIControlState.Normal)
    }
    
}

