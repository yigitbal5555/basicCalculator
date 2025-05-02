//
//  ViewController.swift
//  Calculatorr
//
//  Created by Yiğit Bal on 15.04.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: IBOutlets:
    
    @IBOutlet weak var resultLabel: UILabel!
    
    //MARK: - Properties:
    
    private var currentInput = ""
    private var previousValue = ""
    private var currentOperation: String? = nil
    private var currentOperationTag : OperationType? = nil
    
    //MARK: - LifeCycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
        showLaunchAnimation()
    }
    
    enum OperationType: Int {
        case add, subtract, multiply, divide
        
        init?(tag: Int) {
            switch tag {
            case 12: self = .add
            case 13: self = .subtract
            case 14: self = .multiply
            case 15: self = .divide
            default:
                return nil
            }
        }
    }
    
    //MARK: - IBActions:
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let buttonTag = sender.tag
        if currentInput == "0" {
            currentInput = String(buttonTag)
            
        }
        else {
            currentInput += String(buttonTag)
        }
        resultLabel.text = currentInput
    }
    
    @IBAction func percentTapped(_ sender: UIButton) {
        var currentInput = Double(currentInput) ?? 0
        currentInput = currentInput / 100
        self.currentInput = String(currentInput)
        resultLabel.text = String(currentInput)
    }
    
    @IBAction func plusMinusTapped(_ sender: UIButton) {
        var currentInput = Double(currentInput) ?? 0
        currentInput *= (-1)
        self.currentInput = String(currentInput)
        resultLabel.text = formatResult(currentInput)
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        currentInput = "0"
        resultLabel.text = "0"
        previousValue = ""
        currentOperation = nil
    }
    
    @IBAction func equalTapped(_ sender: UIButton) {
        guard let first = Double(previousValue),
              let second = Double(currentInput),
              let operation = currentOperation else {
            resultLabel.text = "Error"
            return
        }
        
        var result: Double = 0
        
        switch operation {
        case "+":
            result = first + second
        case "-":
            result = first - second
        case "*":
            result = first * second
        case "/":
            result = second != 0 ? first / second : 0
        default:
            resultLabel.text = "Unknown"
            return
        }
        
        resultLabel.text = formatResult(result)
        currentInput = String(result)
        previousValue = ""
        currentOperation = nil
    }
    
    @IBAction func commaTapped(_ sender: UIButton) {
        currentInput += ","
        resultLabel.text = currentInput
    }
    
    @IBAction func operationTapped(_ sender: UIButton) {
        if let operation = OperationType (tag: sender.tag) {
            switch operation {
            case .add:
                currentOperation = "+"
            case .subtract:
                currentOperation = "-"
            case .multiply:
                currentOperation = "*"
            case .divide:
                currentOperation = "/"
            }
            
            previousValue = currentInput
            currentInput = ""
            resultLabel.text = currentOperation
        }
    }
    
    // MARK: - Formatter.
    
    func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(value)
        }
    }
    
    // MARK: - Animation.
    
    func showLaunchAnimation() {
        let screenBounds = UIScreen.main.bounds
        let symbols = ["+", "-", "*", "/"]
        
        for _ in 0..<30 {
            let randomX = CGFloat.random(in: 0...(screenBounds.width - 60))
            let showSymbol = Bool.random()
            let text = showSymbol ? symbols.randomElement()! : "\(Int.random(in: 0...9))"
            
            let label = UILabel(frame: CGRect(x: randomX, y: -75, width: 50, height: 80))
            label.text = text
            label.font = UIFont.boldSystemFont(ofSize: 64)
            label.textAlignment = .center
            label.textColor = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1
            )
            
            view.addSubview(label)
            
            UIView.animate(withDuration: Double.random(in: 1.5...2.5),
                           delay: Double.random(in: 0...0.75),
                           options: .curveEaseInOut,
                           animations: {
                label.frame.origin.y = screenBounds.height + 100
                label.alpha = 0
            }, completion: { _ in
                label.removeFromSuperview()
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.resultLabel.alpha = 1
        }
    }
}
