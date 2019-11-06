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
    @IBOutlet weak var urlTexField: TextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var count: Int = 0 {
        didSet{
            if count == 0 {
                self.showActivityLoader(true)
            }
            if count >= 6{
                self.showActivityLoader(false)
            }
        }
    }
    
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
        
        if let db = DataStore.shared.companyDB{
            self.dbTexField.text = db
        }
        if let url = DataStore.shared.URL{
            self.urlTexField.text = url
        }
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
        if (pass?.count)! > 0{
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
            let password = Globals.user?.UserPWD else {
                self.showMessage(message: "There is error in your login please Log out and login again", type: .error)
                return
        }
        if let url = urlTexField.text , !url.isEmpty{
        DataStore.shared.URL = url
        if let db = dbTexField.text , !db.isEmpty{
            self.showActivityLoader(true)
            ApiManager.shared.userLogin(username: username, password: password, db: db) { (success, error, _) in
                    self.showActivityLoader(false)
                    if success{
                        self.count = 0
                        DataStore.shared.companyDB = db
                        self.getItemsFromServer()
                        self.getEmployeeItemsFromServer()
                        self.getCurrenciesFromServer()
                        self.getUOMFromServer()
                        self.getCustomersFromServer()
                        self.getPriceListFromServer()
                    }
                    if let msg = error?.errorName{
                        self.showMessage(message: msg, type: .error)
                    }
                }
        }else{
            self.showMessage(message: "Enter DB  First", type: .error)
            }
            
        }else{
            self.showMessage(message: "Enter URL First", type: .error)
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
    
    
    @IBAction func sync(_ sender: UIButton) {
        self.checkStatus()
    }
    
    func checkStatus(){
        guard let token = DataStore.shared.token else {
            self.showMessage(message: "First you have to link to URL and Database", type: .error)
            return
        }
        let customerHeaders =  Globals.user?.getAllCustomerHeaders().filter({$0.syncId != nil && $0.HeaderIsSynced == false && $0.isDraft == false}) ?? []
        let employeeHeaders =  Globals.user?.getAllEmployeesHeaders().filter({$0.syncId != nil && $0.HeaderIsSynced == false && $0.isDraft == false }) ?? []
        
        let allHeaders = customerHeaders + employeeHeaders
        if allHeaders.count > 0 {
            let idsString = allHeaders.map{"\($0.id!)-\($0.syncId!)"}.joined(separator: ";")
            self.showActivityLoader(true)
            ApiManager.shared.getExpenseStatus(userToken:  token, ids: idsString) { (success, error, result) in
                if success{
                    for expense in result {
                        if let status = expense.expenseStatus , status != 1{
                            if let header = expense.expense,let oldHeader = allHeaders.first(where: {$0.id == header.id}){
                                header.headerExpensesType = oldHeader.headerExpensesType
                                header.headerUserId = oldHeader.headerUserId
                                header.HeaderIsSynced = true
                                header.HeaderEditable = false
                                header.save()
                            }
                        }
                    }
                    self.showActivityLoader(false)
                    self.syncExpenses()
                }
            }
        }else{
            syncExpenses()
        }
    }
    
    func syncExpenses(){
        let customerHeaders =  Globals.user?.getAllCustomerHeaders().filter({$0.HeaderIsSynced == false && $0.headerStatus == 1 && $0.isDraft == false}) ?? []
        let employeeHeaders =  Globals.user?.getAllEmployeesHeaders().filter({$0.HeaderIsSynced == false && $0.headerStatus == 1 && $0.isDraft == false}) ?? []
        let allHeaders = customerHeaders + employeeHeaders
        let json = JSON(allHeaders.map{$0.dictionaryRepresentation()})
        if allHeaders.count > 0 {
            self.showActivityLoader(true)
            ApiManager.shared.sendExpenses(userToken: DataStore.shared.token ?? "", content: json.rawString() ?? "") { (success, error, result) in
                if success{
                    for res in result{
                        if let state = res.SyncResult,state == true{
                            if let header = allHeaders.first(where: {Int($0.id!) == res.ExpenseId}){
                                header.HeaderIsSynced = true
                                header.syncId = res.SyncId ?? "-1"
                                header.save()
                            }
                        }
                    }
                    self.showActivityLoader(false)
                    self.showMessage(message: "Expenesive List Successfully Synced", type: .success)
                }
                if error != nil{
                    if let msg = error?.errorName{
                        self.showMessage(message: msg, type: .error)
                    }
                }
            }
        }else{
            self.showMessage(message: "No thing to Sync", type: .success)
        }
    }
    
    
    
    func getItemsFromServer(){
        ApiManager.shared.getItems(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                self.count = self.count + 1
                self.showMessage(message: "Item List Successfully downloaded", type: .success)
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    
    func getEmployeeItemsFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getEmployeeItems(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    
                    item.type = ItemType.employee.value
                    item.save()
                }
                self.count = self.count + 1
                self.showMessage(message: "Items List Successfully downloaded", type: .success)
                
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }

        }
    }
    
    
    func getCurrenciesFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getCurrency(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                self.count = self.count + 1
                self.showMessage(message: "Currency List Successfully downloaded", type: .success)
                
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }

        }
    }
    
    
    func getUOMFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getUOMs(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                self.count = self.count + 1
                self.showMessage(message: "UOM List Successfully downloaded", type: .success)
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }

        }
    }
    
    
    
    func getCustomersFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getCustomers(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                self.count = self.count + 1
                self.showMessage(message: "Customer List Successfully downloaded", type: .success)
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    
    
    func getPriceListFromServer(){
        self.showActivityLoader(true)
        ApiManager.shared.getPriceList(userToken: DataStore.shared.token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                self.count = self.count + 1
                self.showMessage(message: "Price List Successfully downloaded", type: .success)
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
}
