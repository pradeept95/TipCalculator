//
//  ViewController.swift
//  Prework
//
//  Created by Diksha Thakur on 8/13/21.
//

import UIKit

class ViewController: UIViewController {
     
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipAmountTextField: UITextField!
    @IBOutlet weak var tipCustomAmountLabel: UILabel!
    
    @IBOutlet weak var tipPercentageView: UIProgressView!
    // var currentTipPercentage = Double(0)
    var tipPercentage = [0.15, 0.18, 0.20]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        billAmountTextField.becomeFirstResponder()
        tipAmountTextField.isHidden = true
        tipCustomAmountLabel.isHidden = true
    }
    
    
    @IBAction func amountChanged(_ sender: Any) {
        calculateTipAmount()
    }
    
    @IBAction func customTipAmountChanged(_ sender: Any) {
        calculateTipAmount()
        updateScreen()
        
    }
    
    
    @IBAction func tipPercentageChanged(_ sender: Any) {
        calculateTipAmount()
        updateScreen()
        
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input tip %..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let name = alert.textFields?.first?.text {
                print("Your name: \(name)")
            }
        }))

        self.present(alert, animated: true)

    }
    
    func calculateTipAmount() {
        
        //get bill amount
        let bill = Double(billAmountTextField.text!) ?? 0
        
        var tip = Double(0)
        let selectedIndex = Int(tipControl.selectedSegmentIndex)
        
        if(selectedIndex != 3){
            tip = bill * self.tipPercentage[selectedIndex]
        }else{
           let tipPer = Double(tipAmountTextField.text!) ?? 0
            
            tip = bill * tipPer/100
        }
          
        let total = bill + tip
            
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        //update tip amount
        tipAmountLabel.text = formatter.string(from: tip as NSNumber)
        
        //update total amount
        totalLabel.text = formatter.string(from: total as NSNumber)
    }
    
    func updateScreen(){
        
        let selectedIndex = Int(tipControl.selectedSegmentIndex)
        
        if(selectedIndex != 3){
            tipAmountTextField.isHidden = true
            tipCustomAmountLabel.isHidden = true
            tipAmountTextField.text = String(0)
            
            tipPercentageView.setProgress( Float(tipPercentage[selectedIndex]), animated: true)
            
        }else{
            tipAmountTextField.isHidden = false
            tipCustomAmountLabel.isHidden = false
            
            tipAmountTextField.becomeFirstResponder()
            
            let tipPer = Double(tipAmountTextField.text!) ?? 0
            
            tipPercentageView.setProgress(Float(tipPer/100), animated: true)
              
        }
    }
}

