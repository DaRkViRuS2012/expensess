//
//  UoM.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

class UoM :CustomStringConvertible{
    var id:Int64
    var title:String
    var userid:Int64
    
    var user:User? {
        return DatabaseManagement.shared.queryUserById(id: userid)
    }
    
    init(id:Int64 ,title:String,userid:Int64) {
        self.id = id
        self.title = title
        self.userid = userid
      
    }
    var description: String {
        return "id = \(self.id), title = \(self.title),"
    }
    
    
    func save(){
        if id == -1{
            id = DatabaseManagement.shared.addUoM(uom: self)!
        }else{
            _ = DatabaseManagement.shared.updateUoM(id: id, uom: self)
        }
    
    }
    
    
    func delete(){
    
    _ = DatabaseManagement.shared.deleteUoM(Id: id)
    
    }
}
