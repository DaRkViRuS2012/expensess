//
//  LoginViewController.swift
//  expenses
//
//  Created by Nour  on 8/2/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class LoginViewController: AbstractController{

     let userDefulat = UserDefaults.standard
  
    @IBOutlet weak var trademarkLbl: UILabel!
    @IBOutlet weak var usernameTxt: ErrorTextField!
    @IBOutlet weak var passwordTxt: ErrorTextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var LoginBtn: FlatButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        usernameTxt.delegate = self
        passwordTxt.delegate = self
        
        self.showNavBackButton  = true
        hideKeyboardWhenTappedAround()
        addKeyboardobserver()
    }

    
    func prepareView(){
 
        usernameTxt.placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 1))
        passwordTxt.placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 1))
        usernameTxt.placeholderActiveColor = .orange
        passwordTxt.placeholderActiveColor = .orange
        usernameTxt.placeholderNormalColor = .gray
        passwordTxt.placeholderNormalColor = .gray
        
        
        usernameTxt.detail = "enter usename"
        passwordTxt.detail = "enter password"
        usernameTxt.detailColor = .red
        passwordTxt.detailColor = .red
        
        usernameTxt.detailLabel.textAlignment = .right
        passwordTxt.detailLabel.textAlignment = .right
        passwordTxt.isErrorRevealed = false
        usernameTxt.isErrorRevealed = false
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1 {
            passwordTxt.becomeFirstResponder()
            return true
        }
        
        endEdit()
        
        return true
    }

    func showAlert(title:String,msg:String){
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
    
    }
    
    
    func validate()->Bool{
        
        let username = usernameTxt.text?.trimmed
        let pass = passwordTxt.text
        
        
        if (username?.isEmpty)! {
            usernameTxt.isErrorRevealed = true
            return false
        }else{
            usernameTxt.isErrorRevealed = false
        }
        
        if (pass?.isEmpty)!{
            passwordTxt.isErrorRevealed = true
            return false
        }else{
            passwordTxt.isErrorRevealed = false
        }

        return true
    }
    
    
    @IBAction func Login(_ sender: UIButton) {
        
        let username = usernameTxt.text?.trimmed
        let pass = passwordTxt.text
        
        if validate(){
        
        
         if let user = DatabaseManagement.shared.queryUserbyNameandPass(username: username!, pass: pass!){
            Globals.user = user
            userDefulat.setValue(user.UserName, forKey: "username")
            userDefulat.setValue(user.UserPWD, forKey: "password")
            let vc = UIStoryboard.viewController(identifier: "HomeViewController") as! HomeViewController
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }else{
            
            
        self.showMessage(message: "username or password incorrect", type: .error)
        }
        
            }
    
    }
}
