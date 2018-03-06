//
//  NewPriceViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import DropDown
class EditPriceViewController: AbstractController {
    
    @IBOutlet weak var valueTxt: UITextField!
    @IBOutlet weak var customersBtn: UIButton!
    @IBOutlet weak var itemBtn: UIButton!
    
    
    var price:Price?
    
    let customersDropDown = DropDown()
    var customers:[Customer] = []
    var customersList:[String] = []
    
    
    let itemDropDown = DropDown()
    var items:[Item] = []
    var itemsList:[String] = []
    
    var itemId:Int64 = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        valueTxt.becomeFirstResponder()
        prepareCustomerList()
        prepareCustomerDropDown()
        prepareItemsList()
        prepareItemDropDown()
        setData()
        self.showNavBackButton = true
    }
    
    
    func setData(){
    valueTxt.text = price?.value
    customersBtn.setTitle(price?.customer?.customerName, for: .normal)
        itemBtn.setTitle(price?.item?.title, for: .normal)
    self.itemId = (price?.item?.id)!
    
    }
    
    
    
    func handelSave(){
        
        endEdit()
        
        
        guard let user = Globals.user else {
            return
        }
        
        let userid = user.UserId
        let value = valueTxt.text?.trimmed
        let customer = customersBtn.currentTitle
        
        if((value?.characters.count)! > 0 && customer != "customers"){
            if let customerid = DatabaseManagement.shared.findCustomer(name: customer!, userid: (Globals.user?.UserId)!){
                var id:Int64 = -1
                if let _ = self.price {
                    id = (self.price?.id)!
                }
                let price = Price(id: id, value: value!, customerid: customerid, itemid: itemId, userid: userid)
                price.save()
                self.navigationController?.popViewController(animated: true)
                
            }
        }else{
            let alert = UIAlertController(title: "Wrong Data", message: "Enter a vaild Price and Customer", preferredStyle: .alert)
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
    
    
    func prepareItemsList(){
        
        //items = DatabaseManagement.shared.queryItems(type: "Category")
        guard let user = Globals.user else{
            return
        }
        items = user.getCustomerItems()
        itemsList = items.map({$0.title})
//        if itemsList.count > 0{
//            itemBtn.setTitle(itemsList[0], for: .normal)
//            self.itemId = self.items[0].id
//        }
    }
    
    
    @IBAction func toggleItemDropDown(_ sender: UIButton) {
        
        if itemDropDown.isHidden{
            itemDropDown.show()
        }else{
            itemDropDown.hide()
        }
    }
    
    func prepareItemDropDown(){
        itemDropDown.anchorView = itemBtn
        
        itemDropDown.dataSource = itemsList
        
        itemDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.itemBtn.setTitle(item, for: .normal)
            self.itemId = self.items[index].id
        }
    }
    
    
    func prepareCustomerList(){
        guard let user = Globals.user else{
            return
        }
        customers = user.getCustomers()
        customersList = customers.map({ $0.customerName })
//        if customersList.count > 0 {
//            customersBtn.setTitle(customersList[0], for: .normal)
//        }
        
    }
    
    
    func prepareCustomerDropDown(){
        
        customersDropDown.anchorView = customersBtn
        customersDropDown.dataSource = customersList
        
        customersDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.customersBtn.setTitle(item, for: .normal)
            
        }
    }
    
    
    @IBAction func toggleCustomerDropDown(_ sender: UIButton) {
        
        if customersDropDown.isHidden{
            customersDropDown.show()
        }else{
            customersDropDown.hide()
        }
    }
    
}
