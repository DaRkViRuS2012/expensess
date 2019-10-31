//
//  UoM.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

class UoM :BaseModel,CustomStringConvertible{
    
    var Uid:Int64?
    var title:String?
    var userid:Int64?
    
    var user:User? {
        return DatabaseManagement.shared.queryUserById(id: userid!)
    }
    
    init(id:Int64 ,title:String,userid:Int64) {
        super.init()
        self.Uid = id
        self.title = title
        self.userid = userid
    }
    
    
    public required init(json: JSON) {
        super.init(json: json)
        self.Uid = json["id"].int64
        self.title = json["title"].string
        self.userid = json["userid"].int64
    }
    
    var description: String {
        return "id = \(self.Uid), title = \(self.title),"
    }
    
    
    func save(){
        if Uid == nil || Uid == -1{
            Uid = DatabaseManagement.shared.addUoM(uom: self)!
            print("UoM JSON \n \n \(dictionaryRepresentation())")
        }else{
            _ = DatabaseManagement.shared.updateUoM(id: Uid!, uom: self)
        }
    
    }
    
    
    func delete(){
    
        _ = DatabaseManagement.shared.deleteUoM(Id: Uid!)
    
    }
    
    
    
    
    public  override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary["id"] = self.Uid
        dictionary["title"] = self.title
        dictionary["userid"] = self.userid
        
        return dictionary
    }
}
