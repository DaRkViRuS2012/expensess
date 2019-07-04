//
//  Item.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

class Item :BaseModel{

    private let kcodeKey = "Code"
    private let ktypeKey = "type"
    private let ktitleKey = "title"
    private let kpriceKey = "Price"
    private let kUoMKey = "UoM"
    private let kiconKey = "icon"
    
    var Itemid:Int64 = -1
    var code:String?
    var type:String?
    var title:String?
    var price:String?
    var UoM:String?
    var icon:String?
    var userid:Int64 = 0
    
    
    init(id:Int64 ,code:String,type:String,title:String,price:String,icon:String,UoM:String,userid:Int64) {
        super.init()
        self.Itemid = id
        self.code = code
        self.type = type
        self.title = title
        self.price = price
        self.UoM = UoM
        self.icon = icon
        self.userid = userid
        
    }
    
    public required init(json: JSON) {
        
        super.init(json: json)
        
        self.code = json[kcodeKey].string
        self.type = json[ktypeKey].string
        self.title = json[ktitleKey].string
        self.price = json[kpriceKey].string
        self.UoM = json[kUoMKey].string
        self.icon = json[kiconKey].string

    }
    
    var description: String {
        return "id = \(self.Itemid), title = \(self.title ?? ""), disc = \(type ?? "")"
    }
    
    
    func save(){
        if self.Itemid == -1 {
            Itemid = DatabaseManagement.shared.addItem(item: self)!
            print("item JSON \n \n \(dictionaryRepresentation())")
        }else{
        
            _ = DatabaseManagement.shared.updateItem(id: self.Itemid, item: self)
        }
        
    }
    

    func delete(){
      _ = DatabaseManagement.shared.deleteItem(Id: self.Itemid)
    }
    
    
    func user() -> User {
        return DatabaseManagement.shared.queryUserById(id: self.userid)!
    }
    
    public  override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
       dictionary["id"] = self.Itemid
       dictionary[kcodeKey] = self.code
       dictionary[ktypeKey] = self.type
       dictionary[ktitleKey] = self.title
       dictionary[kpriceKey] = self.price
       dictionary[kUoMKey] = self.UoM
       dictionary[kiconKey] = self.icon
       dictionary["user"] = self.userid
        
        return dictionary
    }
    

    
}
