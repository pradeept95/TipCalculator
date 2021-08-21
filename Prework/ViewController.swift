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
    var tipPercentage = [0.0, 0.0, 0.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        tipAmountTextField.isHidden = true
        tipCustomAmountLabel.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        billAmountTextField.becomeFirstResponder()
        setSettingValue()
    }
    
    
    @IBAction func amountChanged(_ sender: Any) {
        calculateTipAmount()
    }
    
    @IBAction func customTipAmountChanged(_ sender: Any) {
        
        let newTipPercentage = Double(tipAmountTextField.text!) ?? 0
        
        if(newTipPercentage > 100 || newTipPercentage < 0){
            let alert = UIAlertController(title: "Invalid Tip %, enter tip percentage between 0 and 100", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

                self.tipAmountTextField.becomeFirstResponder()
                self.tipAmountTextField.text = String("")
            }))

            self.present(alert, animated: true)
            
            return
        }
        
        calculateTipAmount()
        updateScreen()
        
    }
    
    
    @IBAction func tipPercentageChanged(_ sender: Any) {
         
        calculateTipAmount()
        updateScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
    }
    
    func calculateTipAmount() {
        
        //get bill amount
        let bill = Double(billAmountTextField.text!) ?? 0
        
        if(bill == 0){
            let alert = UIAlertController(title: "Please, enter your bill amount!", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

                self.billAmountTextField.becomeFirstResponder()
            }))

            self.present(alert, animated: true)
            return
        }
        
        var tip = Double(0)
        let selectedIndex = Int(tipControl.selectedSegmentIndex)
        
        if(selectedIndex != 3){
            tip = bill * self.tipPercentage[selectedIndex]
        }else{
           let tipPer = Double(tipAmountTextField.text!) ?? 0
            
            tip = bill * tipPer/100
        }
          
        let total = bill + tip
            
      
        
        //update tip amount
        tipAmountLabel.text = formatCurrency(amt: tip)
        
        //update total amount
        totalLabel.text =  formatCurrency(amt: total)
    }
    
    func updateScreen(){
        
        let selectedIndex = Int(tipControl.selectedSegmentIndex)
        
        if(selectedIndex != 3){
            tipAmountTextField.isHidden = true
            tipCustomAmountLabel.isHidden = true
            tipAmountTextField.text = String("")
            
            tipPercentageView.setProgress( Float(tipPercentage[selectedIndex]), animated: true)
            
        }else{
            tipAmountTextField.isHidden = false
            tipCustomAmountLabel.isHidden = false
            
            tipAmountTextField.becomeFirstResponder()
            
            let tipPer = Double(tipAmountTextField.text!) ?? 0
            
            tipPercentageView.setProgress(Float(tipPer/100), animated: true)
              
        }
    }
    
    func formatCurrency(amt : Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        return formatter.string(from: amt as NSNumber) ?? String(0)
    }
    
    func setSettingValue(){
        let defaults = UserDefaults.standard
        
        //set first option
        if let firstOpt = defaults.string(forKey: defaultTipPercentage.optOne) {
            tipPercentage[0] = Double(firstOpt) ?? 0.0
        }else{
            defaults.set("0.15", forKey: defaultTipPercentage.optOne)
            tipPercentage[0] = 0.15
        }
        
        //set second option
        if let secondOpt = defaults.string(forKey: defaultTipPercentage.optTwo) {
            tipPercentage[1] = Double(secondOpt) ?? 0.0
        }else{
            defaults.set("0.18", forKey: defaultTipPercentage.optTwo)
            tipPercentage[1] = 0.18
        }
        
        //set second option
        if let thirdOpt = defaults.string(forKey: defaultTipPercentage.optThree) {
            tipPercentage[2] = Double(thirdOpt) ?? 0.0
        }else{
            defaults.set("0.20", forKey: defaultTipPercentage.optThree)
            tipPercentage[2] = 0.20
        }
        
        setPercentageLabel()
    }
    
    
    func setPercentageLabel(){
        
        //changing the title of the tip percentage based on the setting value
        tipControl?.setTitle(String(format: "%3.0f%%", tipPercentage[0]*100), forSegmentAt: 0)
        tipControl?.setTitle(String(format: "%3.0f%%",tipPercentage[1]*100), forSegmentAt: 1)
        tipControl?.setTitle(String(format: "%3.0f%%",tipPercentage[2]*100), forSegmentAt: 2)
        
    }
    
    
    //setting area
}

