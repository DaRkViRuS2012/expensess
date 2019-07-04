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
    
    var itemId:String?
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
    
        if let id = price?.ItemCode{
            self.itemId = id
        }
    
    }
    
    
    
    func handelSave(){
        
        endEdit()
        
        
        guard let user = Globals.user else {
            return
        }
        
        let userid = user.UserId
        let value = valueTxt.text?.trimmed
        
        if((value?.count)! > 0) {
//            if let customer = DatabaseManagement.shared.queryCustomerByPriceId(priceListId: price?.PriceListNum){
                var id:Int64 = -1
                if let _ = self.price {
                    id = (self.price?.Pid)!
                }
            let price = Price(id: id, value: value!, PriceListNum: (self.price?.PriceListNum)!, ItemCode: itemId!, userid: userid)
                price.save()
                self.navigationController?.popViewController(animated: true)
                
//            }
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
            self.itemId = self.items[index].code
        }
    }
    
    
    func prepareCustomerList(){
        guard let user = Globals.user else{
            return
        }
        customers = user.getCustomers()
        customersList = customers.map({ $0.customerName! })
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
