//
//  DocumnetType.swift
//  expenses
//
//  Created by Nour  on 12/5/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

class DocumnetType :CustomStringConvertible{



    var id:Int64?
    var title:String
    var userid:Int64
    
    var user:User? {
        return DatabaseManagement.shared.queryUserById(id: self.userid)
    }

    
    
    init(id:Int64 ,title:String,userid:Int64) {
        self.id = id
        self.title = title
        self.userid = userid
    }
    
    var description: String {
        return "id = \(self.id), title = \(self.title)"
    }
    
    
    func save(){
            id = DatabaseManagement.shared.addDocumnetType(title: self.title, userid: self.userid)
    }
    
    
   
    
    
    
    
}
