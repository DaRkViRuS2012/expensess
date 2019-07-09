//
//  SyncResult.swift
//  expenses
//
//  Created by Nour  on 7/5/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

public class SyncResult:BaseModel{
    public var ExpenseId : Int?
    public var SyncMsg : String?
    public var SyncResult : Bool?
    public var SyncId:String?

    
    
    public required init(json: JSON) {
        super.init(json: json)
        ExpenseId = json["ExpenseId"].int
        SyncMsg = json["SyncMsg"].string
        SyncResult = json["SyncResult"].bool
        SyncId = json["SyncId"].string
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    override public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = super.dictionaryRepresentation()
        //
        //        dictionary.setValue(self.has_Error, forKey: "Has_Error")
        //        dictionary.setValue(self.error_Message, forKey: "Error_Message")
        //        dictionary.setValue(self.xML_data, forKey: "XML_data")
        //        dictionary.setValue(self.invalidSession, forKey: "InvalidSession")
        //        dictionary.setValue(self.documentNumber, forKey: "DocumentNumber")
        
        return dictionary
    }
    
}
