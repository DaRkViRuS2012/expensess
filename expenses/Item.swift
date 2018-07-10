//
//  Item.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation


class Item :CustomStringConvertible{
    var id:Int64
    var code:String
    var type:String
    var title:String
    var price:String
    var UoM:String
    var icon:String
    var userid:Int64
    
    
    init(id:Int64 ,code:String,type:String,title:String,price:String,icon:String,UoM:String,userid:Int64) {
        self.id = id
        self.code = code
        self.type = type
        self.title = title
        self.price = price
        self.UoM = UoM
        self.icon = icon
        self.userid = userid
        
    }
    
    var description: String {
        return "id = \(self.id), title = \(self.title), disc = \(type)"
    }
    
    
    func save(){
        if self.id == -1 {
            
           id = DatabaseManagement.shared.addItem(item: self)!
            print("item JSON \n \n \(dictionaryRepresentation())")
        }else{
        
            _ = DatabaseManagement.shared.updateItem(id: self.id, item: self)
        }
        
    }
    

    func delete(){
      _ = DatabaseManagement.shared.deleteItem(Id: self.id)
    }
    
    
    func user() -> User {
        return DatabaseManagement.shared.queryUserById(id: self.userid)!
    }
    
    public  func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
       dictionary["id"] = self.id
       dictionary["code"] = self.code
       dictionary["type"] = self.type
       dictionary["title"] = self.title
       dictionary["price"] = self.price
       dictionary["UoM"] = self.UoM
       dictionary["icon"] = self.icon
       dictionary["user"] = self.userid
        
        return dictionary
    }
    

    
}
