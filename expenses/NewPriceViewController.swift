//
//  NewPriceViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import DropDown
class NewPriceViewController: AbstractController {

    @IBOutlet weak var valueTxt: UITextField!
    @IBOutlet weak var customersBtn: UIButton!
    @IBOutlet weak var itemBtn: UIButton!
    
    var price:Price?
    
    
    let customersDropDown = DropDown()
    var customers:[Customer] = []
    var customersList:[String] = []
    
    var selectedCustomer:Customer?
    
    let itemDropDown = DropDown()
    var items:[Item] = []
    var itemsList:[String] = []
    
    var itemId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
  
        self.showNavBackButton = true
        if let _ = price{
        setData()
        
        }
    }
    
    
    
    func setData(){
        valueTxt.text = price?.value
        customersBtn.setTitle(price?.customer?.customerName, for: .normal)
        itemBtn.setTitle(price?.item?.title, for: .normal)
        
        if let id = price?.ItemCode{
            self.itemId = id
        }
        
    }
    
    override func customizeView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectItem),
                                               name: NSNotification.Name(rawValue: "selectItem"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectCustomer),
                                               name: NSNotification.Name(rawValue: "selectCustomer"),
                                               object: nil)
    }
    
    
    
    @objc func selectItem(){
        if let item = Globals.item{
            itemBtn.setTitle(item.title, for: .normal)
            self.itemId = item.code
        }
        
    }
    
    
    func handelSave(){
        
        endEdit()
        
        
        guard let user = Globals.user else {
            return
        }
        
        let userid = user.UserId
        let value = valueTxt.text?.trimmed
        let customer = customersBtn.currentTitle
        
        if((value?.count)! > 0 ){
//            if let customerid = DatabaseManagement.shared.findCustomer(name: customer!, userid: (Globals.user?.UserId)!){
            
            let price = Price(id: -1, value: value!, PriceListNum: (self.price?.PriceListNum)!, ItemCode: itemId!, userid: userid)
                price.save()
                self.navigationController?.popViewController(animated: true)
            
//            }
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
        itemsList = items.map({$0.title!})
        if itemsList.count > 0{
            itemBtn.setTitle(itemsList[0], for: .normal)
            self.itemId = self.items[0].code
        }
    }
    
    
    @IBAction func toggleItemDropDown(_ sender: UIButton) {
        
//        if itemDropDown.isHidden{
//            itemDropDown.show()
//        }else{
//            itemDropDown.hide()
//        }
        
        let vc = UIStoryboard.viewController(identifier: "ItemsViewController") as! ItemsViewController
        vc.selectMode = true
        vc.type = false
        self.present(vc, animated: true, completion: nil)
    }
    
    func prepareItemDropDown(){
        itemDropDown.anchorView = itemBtn
        
        itemDropDown.dataSource = itemsList
        
        itemDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.itemBtn.setTitle(item, for: .normal)
            self.itemId = self.items[index].code
        }
    }

    
    func prepareCustomerList(){
        guard let user = Globals.user else{
            return
        }
        customers = user.getCustomers()
        customersList = customers.map({ $0.customerName! })
        if customersList.count > 0 {
            customersBtn.setTitle(customersList[0], for: .normal)
        }
        
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
        
//        if customersDropDown.isHidden{
//            customersDropDown.show()
//        }else{
//            customersDropDown.hide()
//        }
        let vc = UIStoryboard.viewController(identifier: "CustomersViewController") as! CustomersViewController
        vc.selectMode = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func selectCustomer(){
        
        if let customer = Globals.customer{
            customersBtn.setTitle(customer.customerName, for: .normal)
            selectedCustomer = customer
        }
        
    }
    
}
