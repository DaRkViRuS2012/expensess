//
//  Currency.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON
class Currency :BaseModel,CustomStringConvertible{
  
    var Cid:Int64?
    var title:String?
    var userid:Int64?
    
    var user:User?{
        return DatabaseManagement.shared.queryUserById(id: userid!)
    }
    
    
    init(id:Int64 ,title:String,userid:Int64) {
        super.init()
        self.Cid = id
        self.title = title
        self.userid = userid
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        self.Cid = json["id"].int64
        self.title = json["title"].string
        self.userid = json["userid"].int64
    }
    
    var description: String {
        return "id = \(self.Cid), title = \(self.title),"
    }
    
    func save(){
    
        if Cid == nil || Cid == -1{
            Cid = DatabaseManagement.shared.addCurrency(currency: self)!
            print("Currency JSON \n \n \(dictionaryRepresentation())")
        }else{
            _ = DatabaseManagement.shared.updateCurrency(id: Cid!, currency: self)
        }
    
    }
    
    func delete(){
    
        _ = DatabaseManagement.shared.deleteCurrency(Id: Cid!)
    }
    
    
    
    public  override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary["id"] = self.Cid
        dictionary["title"] = self.title
        dictionary["userid"] = self.userid
        
        return dictionary
    }

    
}
