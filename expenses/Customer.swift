//
//  Customer.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation



class Customer :CustomStringConvertible{
    
    
    var Id:Int64
    var customerName:String
    var customerCurrency:String
    var customerCode:String
    
    
    var userid:Int64
    
    var user:User?{
    
    return DatabaseManagement.shared.queryUserById(id: userid)
    
    }
    
    init(Id:Int64 ,customerName:String,customerCurrency:String,userid:Int64,customerCode:String) {
        self.Id = Id
        self.customerName = customerName
        self.customerCurrency = customerCurrency
        self.userid = userid
        self.customerCode = customerCode
    }
    
    
    func getPrice(itemId:Int64)->Price?{
        
       return DatabaseManagement.shared.queryCustomerPrice(customerId: self.Id, itemId: itemId, userid: userid)
    }
    
    
    var description: String {
        return "id = \(self.Id)"
    }
    
    
    func save(){
        if Id == -1{
            Id = DatabaseManagement.shared.addCustomer(customer: self)!
            print("Customer JSON \n \n \(dictionaryRepresentation())")
        }else{
            _ = DatabaseManagement.shared.updateCustomer(id: Id, customer: self)
        }
    
    }
 
    func delete(){
    
        _ = DatabaseManagement.shared.deleteCustomer(Id: Id)
    }
    
    
    
    
    public  func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary["Id"] = self.Id 
        dictionary["customerName"] = self.customerName
        dictionary["customerCurrency"] = self.customerCurrency
        dictionary["userid"] = self.userid
        dictionary["customerCode"] = self.customerCode
        
        return dictionary
    }
}
