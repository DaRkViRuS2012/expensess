//
//  ProfileViewController.swift
//  expenses
//
//  Created by Nour  on 11/14/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class ProfileViewController: AbstractController{
    
    let userDefulat = UserDefaults.standard

    @IBOutlet weak var password: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var lastNameTxt: TextField!
    @IBOutlet weak var firstNameTxt: TextField!
    
    
    @IBOutlet weak var confirm: TextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = Globals.user
        
       // addKeyboardobserver()
       // self.showNavBackButton  = true
        prepareView()
    }
    
    
    func prepareView(){
        
        
        password.placeholderNormalColor = .darkGray
        emailTxt.placeholderNormalColor = .darkGray
        lastNameTxt.placeholderNormalColor = .darkGray
        firstNameTxt.placeholderNormalColor = .darkGray
        confirm.placeholderNormalColor = .darkGray
        
        password.placeholderActiveColor = .gray
        emailTxt.placeholderActiveColor = .gray
        lastNameTxt.placeholderActiveColor = .gray
        firstNameTxt.placeholderActiveColor = .gray
        confirm.placeholderActiveColor = .gray
        
   
        // load data 
        
        emailTxt.text = user?.UserEmail
        firstNameTxt.text = user?.UserFirstName
        lastNameTxt.text = user?.UserLastName
        
        
    }
    
   
    func logout(){
     DataStore.shared.logout()
    }
    
    func showAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func handleNewAccount(_ sender: UIButton) {
        
        let email = emailTxt.text?.trimmed
        
        let firstName = firstNameTxt.text?.trimmed
        let lastname = lastNameTxt.text?.trimmed
        
        let pass = password.text
        let confirm = self.confirm.text
    
        if pass != confirm {
            showAlert(title: "", msg: "Password confirm is not the same")
            return
        }
        
        
        if (email?.isEmpty)! || (firstName?.isEmpty)! || (lastname?.isEmpty)! {
            showAlert(title: "Invalid Data", msg: "Please make sure you entered a vaild data")
            return
        }
        
        
        user?.UserFirstName = firstName!
        user?.UserLastName = lastname!
        user?.UserEmail = email!
        
        if (pass?.characters.count)! > 0{
            user?.UserPWD = pass!
        }
        user?.save()
        self.popOrDismissViewControllerAnimated(animated: true)
        
        
    }
    
    @IBAction func handelLogout(_ sender: UIButton) {
        logout()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (firstNameTxt.isFirstResponder){
            lastNameTxt.becomeFirstResponder()
        }else  if (lastNameTxt.isFirstResponder){
            emailTxt.becomeFirstResponder()
        }else if (emailTxt.isFirstResponder){
            emailTxt.resignFirstResponder()
        }
        return true
    }

}
