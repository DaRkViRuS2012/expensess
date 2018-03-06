//
//  header.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

class Line : CustomStringConvertible{
    
    var Id:Int64
    var headerId:Int64
    var Qty:Double
    var Amount:Double
    var currency:String
    var ItemDiscription:String
    var LinePrice:Double
    var ItemId:Int64
    var LineUoM:String
    var userid:Int64
    
    
    
    var item:Item?{
        return DatabaseManagement.shared.queryItem(itemid: ItemId)
    }
    
    var user:User?{
        return DatabaseManagement.shared.queryUserById(id: userid)
    }
    
    var header:Header?{
        return DatabaseManagement.shared.queryHeaderById(id: headerId)
    }
    
  
    init(Lineid:Int64 ,headerId:Int64,Qty:Double,Amount:Double,currency:String,ItemDiscription:String,LinePrice:Double,ItemId:Int64,Lineuom:String,userid:Int64) {
        
        self.Id = Lineid
        self.headerId = headerId
        self.Qty = Qty
        self.Amount = Amount
        self.currency = currency
        self.ItemDiscription = ItemDiscription
        self.LinePrice = LinePrice
        self.ItemId = ItemId
        self.LineUoM = Lineuom
        self.userid = userid
    }
    
    var description: String {
        return "id = \(self.Id)"
    }
    
    
    func save(){
        if Id == -1 {
            Id = DatabaseManagement.shared.addLine(line: self)!
        }else{
            _ = DatabaseManagement.shared.updateLine(id: Id, line: self)
        }
    }
    
    func delete(){
      
        _ = DatabaseManagement.shared.deleteLine(Id: self.Id)
        
    }
    
}
