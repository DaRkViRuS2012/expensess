//
//  Price.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

class Price :CustomStringConvertible{
    var id:Int64
    var value:String
    var customerid:Int64
    var itemid:Int64
    var userid:Int64
    
    
    
    
    var customer:Customer?{
        return DatabaseManagement.shared.queryCustomerById(customerid:customerid)
    }
    
    
    var item:Item? {
        return DatabaseManagement.shared.queryItem(itemid: itemid)
    }
    
    var user:User?{
        return DatabaseManagement.shared.queryUserById(id: userid)
    }
    
    init(id:Int64 ,value:String,customerid:Int64,itemid:Int64,userid:Int64) {
        self.id = id
        self.value = value
        self.customerid = customerid
        self.itemid = itemid
        self.userid = userid
    }
    var description: String {
        return "id = \(self.id ?? 0), title = \(self.value),item \(self.itemid), customer \(self.customerid)"
    }
    
    func save(){
        if id == -1 {
            id = DatabaseManagement.shared.addPrice(price: self)!
            print("Price List JSON \n \n \(dictionaryRepresentation())")
        }else{
        
            _ = DatabaseManagement.shared.updatePrice(id: id, price: self)
        
        }
    }
    
    func delete(){
    
    _ = DatabaseManagement.shared.deletePrice(Id: id)
    
    }
    
    
    
    
    public  func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]

        dictionary["id"] = self.id 
        dictionary["value"] = self.value
        dictionary["customerid"] = self.customerid
        dictionary["itemid"] = self.itemid
        dictionary["userid"] = self.userid
        
        return dictionary
    }
}
