//
//  ExpensesResult.swift
//  expenses
//
//  Created by Nour  on 7/9/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON


public class ExpensesResult:BaseModel{
    public var expenseId : Int?
    public var expenseStatus : Int?
    public var expense : Header?

    
    public required init(json: JSON) {
        super.init(json: json)
        expenseId = json["ExpenseId"].int
        expenseStatus = json["ExpenseStatus"].int
        if json["Expense"] != JSON.null{
            expense = Header(json:json["Expense"])
        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    override public func dictionaryRepresentation() -> [String:Any] {
        
        let dictionary = super.dictionaryRepresentation()
        
        return dictionary
    }
    
}



