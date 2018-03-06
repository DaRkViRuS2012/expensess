//
//  NewCustomerViewController.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import DropDown
class NewCustomerViewController: AbstractController{
    
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerCode: UITextField!
  
  
    @IBOutlet weak var customerCurrency: UIButton!
    
    let PricedropDown = DropDown()
    let CurrencydropDown = DropDown()
    var prices:[Price] = []
    var pricelist:[String] = []
    var currencies:[Currency]  = []
    var currencieslist:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavCloseButton = true
        loadCurrencies()
        prepareCurrncyDropDown()
        
    }
    
    
    func loadCurrencies(){
        guard let user = Globals.user else{
            return
        }
        
        currencies = user.getCurrencies()
       
        if(currencies.count>0){
            customerCurrency.setTitle(currencies[0].title, for: .normal)
        }
        currencieslist = currencies.map({ $0.title })
    }

    
    
    
    

    
    
    func prepareCurrncyDropDown(){
    
        CurrencydropDown.anchorView = customerCurrency
        CurrencydropDown.dataSource = currencieslist
        CurrencydropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.customerCurrency.setTitle(item, for: .normal)
        }
    
    }
    
    
    
    @IBAction func toggoleCurrencyDropDown(_ sender: UIButton) {
        
        if CurrencydropDown.isHidden{
            CurrencydropDown.show()
        }else{
            CurrencydropDown.hide()
        }
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        
        
        
        let name = customerName.text?.trimmed
        let code = customerCode.text?.trimmed
        
        let currency  = customerCurrency.titleLabel?.text
        guard let user = Globals.user else{
            return
        }
      
       
        let userid = user.UserId
        if((name?.characters.count)! > 0 && (code?.characters.count)! > 0 && currency != "Currency"){
            
            let customer = Customer(Id: -1, customerName: name!, customerCurrency: currency!, userid: userid, customerCode: code!)
            customer.save()
            self.dismiss(animated: true, completion: nil)
            
           self.popOrDismissViewControllerAnimated(animated: true)
           
        }else{
            let alert = UIAlertController(title: "Wrong Data", message: "Enter a vaild data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        endEdit()
        
        return true
    }
    
    
    


}
