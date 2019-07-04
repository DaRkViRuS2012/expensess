//
//  image.swift
//  expenses
//
//  Created by Nour  on 11/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import UIKit
import SQLite
class Image:CustomStringConvertible{

    var id:Int64?
    var title:String
    var userid:Int64
    var headerId:Int64
    
    var image:UIImage?{
        return UIImage.fromDatatypeValue(self.data)
    }
    var data:Blob
    
    var user:User? {
        return DatabaseManagement.shared.queryUserById(id: self.userid)
    }
//    var line:Line?{
//        return DatabaseManagement.shared.queryLineById(id: lineid)
//    }
    
    var header:Header?{
        return DatabaseManagement.shared.queryHeaderById(id: self.headerId)
    }
    
    
    init(id:Int64 ,title:String,headerId:Int64,userid:Int64,data:Blob) {
        self.id = id
        self.title = title
        self.userid = userid
        self.headerId = headerId
        self.data = data
    }
    
    var description: String {
        return "id = \(self.id), title = \(self.title)"
    }
    
    
    func save(){
        if self.id == -1 {
            id = DatabaseManagement.shared.addImage(headerid: headerId, image: title,data:self.data, userid: userid)
            print("Image JSON \n \n \(dictionaryRepresentation())")
        }else{
          _ =  DatabaseManagement.shared.updateImage(id: self.id!, image: self)
        }
    }
    
    
    func delete(){
        _ = DatabaseManagement.shared.deleteImage(Id: self.id!)
    }
    
    
    
    public  func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
            dictionary["id"] = self.id
            dictionary["title"] = self.title
          //  dictionary["userid"] = self.userid
            //dictionary["headerId"] = self.headerId
            dictionary["data"] = self.data
        return dictionary
    }
    
    

}
