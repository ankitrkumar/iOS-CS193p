//
//  ViewController.swift
//  Calculator
//
//  Created by Ankit Kumar on 5/25/15.
//  Copyright (c) 2015 Ankit Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
  
    @IBOutlet weak var history: UILabel!
    
    var userTyping = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userTyping)
        {
            if(digit == ".") && (display.text!.rangeOfString(".") != nil){
            return
            }
            display.text = display.text! + digit
        }
        else
        {
            if (digit == "."){
                display.text = "0."
            }
            else{
            display.text = digit
            userTyping = true
            }
        }
        
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
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }
        else{
            displayValue = 0 //really lame change displayValue for to an optional to return a nil
        }
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            history.text = brain.showHistory()
            userTyping = false
        }
    }	
    
    @IBAction func operate(sender: UIButton) {
        if(userTyping){
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            
            }
            else{
                displayValue = 0 //really lame change displayValue for to an optional to return a nil
            }
        }
        
        
    }
    
}

