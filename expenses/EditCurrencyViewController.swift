//
//  NewCurrencyViewController.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class EditCurrencyViewController: AbstractController {
    
    
    @IBOutlet weak var titleTxt: UITextField!
    
    var currency:Currency?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTxt.becomeFirstResponder()
        setData()
        self.showNavBackButton = true
    }
    
    
    func setData(){
        titleTxt.text = currency?.title
    }
    
    
    
    
    func handelsave(){
        
        endEdit()
        
        
        guard let user = Globals.user else {
            return
        }
        
        let userid = user.UserId
        
        let value = titleTxt.text?.trimmed
        if((value?.characters.count)! > 0 ){
            
            let currency = Currency(id: (self.currency?.Cid)!, title: value!, userid: userid)
            currency.save()
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Wrong Data", message: "Enter a vaild currency", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func save(_ sender: UIButton) {
        handelsave()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handelsave()
        return true
    }
    
    
}
