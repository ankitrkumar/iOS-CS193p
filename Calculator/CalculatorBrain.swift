//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ankit Kumar on 7/15/15.
//  Copyright (c) 2015 Ankit Kumar. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op :Printable
    {
        case Operand(Double)
        case NullaryOperation(String, () -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        case Variable(String)
        
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .NullaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    var variableValues = [String:Double]()
    
    private var knownOps = [String: Op]()
     //dictionary always returns an optional so check with an if to see with an if to avoid program crashes
    init() {
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("x", *))
        learnOp(Op.BinaryOperation("/") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.NullaryOperation("π", { M_PI }))
        learnOp(Op.UnaryOperation("+/-") { -$0 })
    }
    
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps:[Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .NullaryOperation(_, let operation):
                return(operation(),remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return (variableValues[symbol], remainingOps)
            }
        }
        return (nil,ops)
        
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand:Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func pushOperand(symbol : String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String)-> Double?
    {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func backSpace() -> Double?
    {
        return 0
    }
    
    func showHistory() -> String?
    {
        return " ".join(opStack.map{ "\($0)" })
    }
    
    func clearAll() {
        opStack = []
    }
}