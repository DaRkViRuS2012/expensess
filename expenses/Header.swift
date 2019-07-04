//
//  header.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation

enum expensesType{
    
    case Employee
    case Customer
    
    var value:Int{
        switch self {
        case .Employee:
            return 1
        case .Customer:
            return 0
        }
    }
    
}


class Header :CustomStringConvertible{
    var id:Int64
    var headerUserId:Int64
    var headerKey:String?
    var headerCreatedDate:Date?
    var headerPostedDate:Date?
    var headerUpdatedDate:Date?
    var headerExpensesType:String?
    var headerCustomerId:Int64?
    var headerStatus:Int?
    var expaded:Bool
    var headerPhoneNumber:String?
    var headerBillingAddress:String?
    var headerShippingAddress:String?
    var headerContactPerson:String?
    var headerDocumenetType:String?
    var headerCostSoruce:String?
    var HeaderEditable:Bool?
    var HeaderIsSynced:Bool?
    
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
    
    
    var images:[Image]{
        return DatabaseManagement.shared.queryHeaderImages(headerid: id)
    }
    init(id:Int64 ,headerUserId:Int64,headerCreatedDate:Date,headerPostedDate:Date,headerUpdateDate:Date?,headerExpensesType:String,headerCustomerId:Int64?,headerisApproved:ExpensesState,expaded:Bool = false,headerPhoneNumber:String?,headerBillingAddress:String?,headerShippingAddress:String?,headerContactPerson:String?,headerDocumenetType:String? = nil , headerEditable:Bool? = false,headerIsSynced:Bool? = false,headerCostSource:String) {
        self.id = id
        self.headerUserId = headerUserId
        self.headerCreatedDate = headerCreatedDate
        self.headerPostedDate = headerPostedDate
        self.headerExpensesType = headerExpensesType
        self.headerCustomerId = headerCustomerId
        self.headerStatus = headerisApproved.state
        self.headerKey = "\(id)"
        self.expaded = expaded
        self.headerPhoneNumber = headerPhoneNumber
        self.headerBillingAddress = headerBillingAddress
        self.headerShippingAddress = headerShippingAddress
        self.headerContactPerson = headerContactPerson
        self.headerDocumenetType = headerDocumenetType
        self.HeaderEditable = headerEditable
        self.HeaderIsSynced = headerIsSynced
        self.headerCostSoruce = headerCostSource
        self.headerUpdatedDate = headerUpdateDate
    }
    
    var description: String {
        return "id = \(self.id), title = \(self.headerCreatedDate), Key = \(self.headerKey)"
    }
    func save(){
        if id == -1{
        id = DatabaseManagement.shared.addHeader(header: self)!
        print("header")
        print(dictionaryRepresentation())
        print("================")
        }else{
            _ = DatabaseManagement.shared.updateHeader(id: id, header: self)
            print("header")
            print(dictionaryRepresentation())
            print("================")
        }
    }
    
    
    func delete(){
        for line in HeaderLines{
            line.delete()
        }
        for image in images{
            image.delete()
        }
        _ = DatabaseManagement.shared.deleteHeader(Id: id)
    }
    
    
    
    public  func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary["id"] = self.id
        dictionary["headerUserId"] = self.headerUserId
        dictionary["headerCreatedDate"] = self.headerCreatedDate
        dictionary["headerPostedDate"] = self.headerPostedDate
        dictionary["headerExpensesType"] = self.headerExpensesType
        dictionary["headerCustomerCode"] = self.headerCustomerId
        dictionary["headerStatus"] = self.headerStatus
        dictionary["headerKey"] = self.headerKey
        dictionary["expaded"] = self.expaded
        dictionary["headerPhoneNumber"] = self.headerPhoneNumber
        dictionary["headerBillingAddress"] = self.headerBillingAddress
        dictionary["headerShippingAddress"] = self.headerShippingAddress
        dictionary["headerContactPerson"] = self.headerContactPerson
        dictionary["headerDocumenetType"] = HeadrDocumentTypeValue(val:self.headerDocumenetType)
        dictionary["HeaderIsSynced"] = self.HeaderIsSynced
        dictionary["HeaderEditable"] = self.HeaderEditable
        dictionary["headerUpdatedDate"] = self.headerUpdatedDate
        dictionary["headerCostSoruce"] = self.headerCostSoruce

        dictionary["lines"] = HeaderLines.map{$0.dictionaryRepresentation()}
        dictionary["images"] = self.images.map{$0.dictionaryRepresentation()}
        return dictionary
    }
    
    
    
    func  HeadrDocumentTypeValue(val:String?)->Int?{
        switch val {
        case "Quotation"?:
            return 23
        case "Order"?:
            return 17
        case "Delivery"?:
            return 15
        case "Return"?:
            return 16
        case "Invoice"?:
            return 13
        case "Credit_Note"?:
            return 14
        default:
            return nil
        }
    }
    

    
    
}
