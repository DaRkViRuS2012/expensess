//
//  ProfileViewController.swift
//  expenses
//
//  Created by Nour  on 11/14/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import SwiftyJSON

class ProfileViewController: AbstractController{
    
    let userDefulat = UserDefaults.standard

    @IBOutlet weak var password: TextField!
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var lastNameTxt: TextField!
    @IBOutlet weak var firstNameTxt: TextField!
    
    
    @IBOutlet weak var confirm: TextField!
    @IBOutlet weak var dbTexField: TextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = Globals.user
        
       // addKeyboardobserver()
       // self.showNavBackButton  = true
        prepareView()
        
        if let db = DataStore.shared.companyDB{
            self.dbTexField.text = db
        }
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
    
    
    @IBAction func handelSync(_ sender: UIButton) {
        
        
        guard let username = Globals.user?.UserName ,
            let password = Globals.user?.UserPWD else {return}
    

        if let db = dbTexField.text , !db.isEmpty{
            self.showActivityLoader(true)
            ApiManager.shared.userLogin(username: username, password: password, db: db) { (success, error, _) in
                    self.showActivityLoader(false)
                    if success{
                        DataStore.shared.companyDB = db
                        self.getItemsFromServer()
                        self.getEmployeeItemsFromServer()
                        self.getCurrenciesFromServer()
                        self.getUOMFromServer()
                        self.getCustomersFromServer()
                        self.getPriceListFromServer()
                        self.syncExpenses()
                    }
                    if let msg = error?.errorName{
                        self.showMessage(message: msg, type: .error)
                    }
                }
        }else{
            self.showMessage(message: "Enter DB URL First", type: .error)
        }
       
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (firstNameTxt.isFirstResponder){
            _ = lastNameTxt.becomeFirstResponder()
        }else  if (lastNameTxt.isFirstResponder){
            _ = emailTxt.becomeFirstResponder()
        }else if (emailTxt.isFirstResponder){
            emailTxt.resignFirstResponder()
        }
        return true
    }
    
    
    func syncExpenses(){
        
        let customerHeaders =  Globals.user?.getAllCustomerHeaders().filter({$0.HeaderIsSynced == false}) ?? []
        let employeeHeaders =  Globals.user?.getAllEmployeesHeaders().filter({$0.HeaderIsSynced == false}) ?? []
        let allHeaders = customerHeaders + employeeHeaders
        
        
        let json = JSON(allHeaders.map{$0.dictionaryRepresentation()})
        if allHeaders.count > 0{
            self.showActivityLoader(true)
            ApiManager.shared.sendExpenses(userToken: DataStore.shared.token ?? "", content: json.rawString() ?? "") { (success, error, result) in
                self.showActivityLoader(false)
                if success{
                    for res in result{
                        if let state = res.SyncResult,state == true{
                            if let header = allHeaders.first(where: {Int($0.id) == res.ExpenseId}){
                                header.HeaderIsSynced = true
                                header.syncId = res.SyncId ?? "-1"
                                header.save()
                            }
                        }
                    }
                }
                
                if error != nil{
                    
                }
            }
            
        }
        
        
    }
    
    
    
    func getItemsFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getItems(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
            }
        }
    }
    
    
    func getEmployeeItemsFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getEmployeeItems(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    
                    item.type = ItemType.employee.value
                    item.save()
                }
                
                
            }
        }
    }
    
    
    func getCurrenciesFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getCurrency(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    
    
    func getUOMFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getUOMs(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    
    
    
    func getCustomersFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getCustomers(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    
    
    
    func getPriceListFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getPriceList(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    

}
