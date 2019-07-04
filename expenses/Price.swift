//
//  Price.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON
class Price :BaseModel,CustomStringConvertible{
    var Pid:Int64?
    var value:String?
    var PriceListNum:String?
    var ItemCode:String?
    var userid:Int64?
    
    
    
    
    var customer:Customer?{
        
        return DatabaseManagement.shared.queryCustomerByPriceId(priceListId: PriceListNum ?? "-1")
    }
    
    
    var item:Item? {
        return DatabaseManagement.shared.queryItem(itemCode: ItemCode ?? "-1")
    }
    
    var user:User?{
        return DatabaseManagement.shared.queryUserById(id: userid!)
    }
    
    init(id:Int64 ,value:String,PriceListNum:String,ItemCode:String,userid:Int64) {
        super.init()
        self.Pid = id
        self.value = value
        self.PriceListNum = PriceListNum
        self.ItemCode = ItemCode
        self.userid = userid
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        self.Pid = json["id"].int64
        self.value = json["value"].string
        self.PriceListNum = json["PriceListNum"].string
        self.ItemCode = json["ItemCode"].string
        self.userid = json["userid"].int64
    }
    
    var description: String {
        return "id = \(self.Pid ?? 0), title = \(self.value),item \(self.ItemCode), customer \(self.PriceListNum)"
    }
    
    func save(){
        if Pid == nil {
            Pid = DatabaseManagement.shared.addPrice(price: self)!
            print("Price List JSON \n \n \(dictionaryRepresentation())")
        }else{
        
            _ = DatabaseManagement.shared.updatePrice(id: Pid!, price: self)
        
        }
    }
    
    func delete(){
    
        _ = DatabaseManagement.shared.deletePrice(Id: Pid!)
    
    }
    
    
    
    
    public  override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]

        dictionary["id"] = self.Pid 
        dictionary["value"] = self.value
        dictionary["PriceListNum"] = self.PriceListNum
        dictionary["ItemCode"] = self.ItemCode
        dictionary["userid"] = self.userid
        
        return dictionary
    }
}
