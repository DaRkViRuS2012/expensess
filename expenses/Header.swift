//
//  header.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

class Header :CustomStringConvertible{
    
    
    var id:Int64
    var headerUserId:Int64
    var headerKey:String
    var headerCreatedDate:Date
    var headerPostedDate:Date
    var headerExpensesType:String
    var headerCustomerId:Int64?
    var headerisApproved:Int
    var expaded:Bool
    var headerPhoneNumber:String?
    var headerBillingAddress:String?
    var headerShippingAddress:String?
    var headerContactPerson:String?
    var headerDocumenetType:String?
    
    
    var headerCustomerCode:String?{
        if let _ = headerCustomerId{
            return customer?.customerCode
        }
        return nil
    
    }
    var customer:Customer?{
        if let _ = headerCustomerId{
            return DatabaseManagement.shared.queryCustomerById(customerid: headerCustomerId!)
        }
        return nil
    }
    
    var HeaderLines:[Line]{
        return DatabaseManagement.shared.queryheaderLines(headerid:id)
    }
    
    
    var images:[Image]?{
        return DatabaseManagement.shared.queryHeaderImages(headerid: id)
    }
    
    
    init(id:Int64 ,headerUserId:Int64,headerCreatedDate:Date,headerPostedDate:Date,headerExpensesType:String,headerCustomerId:Int64?,headerisApproved:ExpensesState,expaded:Bool = false,headerPhoneNumber:String?,headerBillingAddress:String?,headerShippingAddress:String?,headerContactPerson:String?,headerDocumenetType:String? = nil) {
        self.id = id
        self.headerUserId = headerUserId
        self.headerCreatedDate = headerCreatedDate
        self.headerPostedDate = headerPostedDate
        self.headerExpensesType = headerExpensesType
        self.headerCustomerId = headerCustomerId
        self.headerisApproved = headerisApproved.state
        self.headerKey = "\(headerUserId)\(id)"
        self.expaded = expaded
        self.headerPhoneNumber = headerPhoneNumber
        self.headerBillingAddress = headerBillingAddress
        self.headerShippingAddress = headerShippingAddress
        self.headerContactPerson = headerContactPerson
        self.headerDocumenetType = headerDocumenetType
    }
    
    var description: String {
        return "id = \(self.id), title = \(self.headerCreatedDate), Key = \(self.headerKey)"
    }
    func save(){
        if id == -1{
        id = DatabaseManagement.shared.addHeader(header: self)!
        
        }else{
            _ = DatabaseManagement.shared.updateHeader(id: id, header: self)
        }
    }
    
    
    func delete(){
    
        for line in HeaderLines{
            line.delete()
        }
        
        for image in images!{
            image.delete()
        }
        _ = DatabaseManagement.shared.deleteHeader(Id: id)
    }
}
