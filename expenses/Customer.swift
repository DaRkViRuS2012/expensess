//
//  Customer.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

import SwiftyJSON

class Customer :BaseModel,CustomStringConvertible{
    
    
    var CId:Int64?
    var customerName:String?
    var customerCurrency:String?
    var customerCode:String?
    var PriceListNum:String?
    
    
    var userid:Int64?
    
    var user:User?{
    
    return DatabaseManagement.shared.queryUserById(id: userid!)
    
    }
    
    init(Id:Int64 ,customerName:String,customerCurrency:String,userid:Int64,customerCode:String,pricelistnum:String?) {
        super.init()
        self.CId = Id
        self.customerName = customerName
        self.customerCurrency = customerCurrency
        self.userid = userid
        self.customerCode = customerCode
        self.PriceListNum = pricelistnum
    }
    
    required init(json: JSON) {
        super.init(json: json)
        
        self.CId = json["id"].int64
        self.customerName = json["customerName"].string
        self.customerCode = json["customerCode"].string
        self.customerCurrency = json["customerCurrency"].string
        self.userid = json["userid"].int64
        self.PriceListNum = json["PriceListNum"].string
        
    }
    
    func getPrice(itemCode:String)->Price?{
        
        return DatabaseManagement.shared.queryCustomerPrice(pricelistnum: self.PriceListNum!, itemCode: itemCode, userid: userid!)
    }
    
    
    var description: String {
        return "id = \(self.CId)"
    }
    
    
    func save(){
        if CId == nil || CId == -1{
            CId = DatabaseManagement.shared.addCustomer(customer: self)!
            print("Customer JSON \n \n \(dictionaryRepresentation())")
        }else{
            _ = DatabaseManagement.shared.updateCustomer(id: CId!, customer: self)
        }
    
    }
 
    func delete(){
    
        _ = DatabaseManagement.shared.deleteCustomer(Id: CId!)
    }
    
    
    
    
    public  override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary["Id"] = self.CId
        dictionary["customerName"] = self.customerName
        dictionary["customerCurrency"] = self.customerCurrency
        dictionary["userid"] = self.userid
        dictionary["customerCode"] = self.customerCode
        dictionary["PriceListNum"] = self.PriceListNum
        
        return dictionary
    }
}
