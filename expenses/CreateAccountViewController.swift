//
//  CreateAccountViewController.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material

class CreateAccountViewController: AbstractController{


    @IBOutlet weak var password: ErrorTextField!
    @IBOutlet weak var emailTxt: ErrorTextField!
    @IBOutlet weak var lastNameTxt: ErrorTextField!
    @IBOutlet weak var firstNameTxt: ErrorTextField!
    @IBOutlet weak var createBtn: FlatButton!
    @IBOutlet weak var username: ErrorTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardobserver()
        self.showNavBackButton  = true
       prepareView()
    }

    
    func prepareView(){
        
        password.placeholderNormalColor = .darkGray
        emailTxt.placeholderNormalColor = .darkGray
        lastNameTxt.placeholderNormalColor = .darkGray
        firstNameTxt.placeholderNormalColor = .darkGray
        username.placeholderNormalColor = .darkGray
        
        password.placeholderActiveColor = .gray
        emailTxt.placeholderActiveColor = .gray
        lastNameTxt.placeholderActiveColor = .gray
        firstNameTxt.placeholderActiveColor = .gray
        username.placeholderActiveColor = .gray
        
        
        
        password.detail = "enter password"
        emailTxt.detail = "enter a vaild email"
        lastNameTxt.detail = "enter last name"
        firstNameTxt.detail = "enter first name"
        username.detail = "enter username"
        
        username.detailLabel.textAlignment = .right
        emailTxt.detailLabel.textAlignment = .right
        password.detailLabel.textAlignment = .right
        firstNameTxt.detailLabel.textAlignment = .right
        lastNameTxt.detailLabel.textAlignment = .right
     
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func showAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
    func validate()->Bool{
        let email = emailTxt.text?.trimmed
        let pass = password.text
        let firstName = firstNameTxt.text?.trimmed
        let lastname = lastNameTxt.text?.trimmed
        let userName = username.text
        
        
        if (firstName?.isEmpty)!{
            firstNameTxt.isErrorRevealed = true
            return false
        }else{
            firstNameTxt.isErrorRevealed = false
        }
        
        if (lastname?.isEmpty)! {
            lastNameTxt.isErrorRevealed = true
            return false
        }else{
            lastNameTxt.isErrorRevealed = false
        }
        
        if (email?.isEmpty)! || !(email?.isValidEmail())!{
            emailTxt.isErrorRevealed = true
            return false
        }else{
            emailTxt.isErrorRevealed = false
        }
        
        if (userName?.isEmpty)! {
            username.isErrorRevealed = true
            return false
        }else{
            username.isErrorRevealed = false
        }
        
        if (pass?.isEmpty)! {
            password.isErrorRevealed = true
            return false
        }else{
            password.isErrorRevealed = false
        }
        
        return true
    }
    
    @IBAction func handleNewAccount(_ sender: UIButton) {
        
        let email = emailTxt.text?.trimmed
        let pass = password.text
        let firstName = firstNameTxt.text?.trimmed
        let lastname = lastNameTxt.text?.trimmed
        let userName = username.text
        
        if validate(){
     
        
        let user = User(id: 0, UserFirstName: firstName!, UserLastName: lastname!,UserEmail:email!, UserName: userName!, UserImage: "", UserPWD: pass!, UserisActive: true, UserVendorCode: nil)
        if let _ = DatabaseManagement.shared.addUser(user: user){
            self.popOrDismissViewControllerAnimated(animated: true)
        }else{
            showMessage(message: "username already exist", type: .error)
        }
        
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (firstNameTxt.isFirstResponder){
            lastNameTxt.becomeFirstResponder()
            return true
        }
        
        if (lastNameTxt.isFirstResponder){
            emailTxt.becomeFirstResponder()
            return true
        }
        if (emailTxt.isFirstResponder){
            password.becomeFirstResponder()
            return true
        }
        return true
    }

}
