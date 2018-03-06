//
//  NewUoMViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class EditUoMViewController: AbstractController {
    
    var uom:UoM?
    
    @IBOutlet weak var titleTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTxt.becomeFirstResponder()
        setData()
        self.showNavBackButton = true
    }
    
    
    func setData(){
    
        titleTxt.text = uom?.title
    
    }
    
    func handelSave(){
        
        endEdit()
        
        
        guard let user = Globals.user else {
            return
        }
        
        let userid = user.UserId
        
        let value = titleTxt.text?.trimmed
        if((value?.characters.count)! > 0 ){

            var id:Int64 = -1
            if let _ = self.uom {
                id = (self.uom?.id)!
            }
            let uom = UoM(id: id, title: value!, userid: userid)
            uom.save()
            self.navigationController?.popViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Wrong Data", message: "Enter a vaild UoM", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        handelSave()
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handelSave()
        return true
    }
    
    
}
