//
//  header.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation
import SwiftyJSON

enum expensesType{
    
    case Employee
    case Customer
    
    var value:Int {
        switch self {
        case .Employee:
            return 1
        case .Customer:
            return 0
        }
    }
    
}


public class Header :BaseModel,CustomStringConvertible{
    var id:Int64?
    var headerUserId:Int64?
    var headerKey:String?
    var headerCreatedDate:Date?
    var headerPostedDate:Date?
    var headerUpdatedDate:Date?
    var headerExpensesType:String?
    var headerCustomerId:Int64?
    var headerStatus:Int?
    var expaded:Bool?
    var headerPhoneNumber:String?
    var headerBillingAddress:String?
    var headerShippingAddress:String?
    var headerContactPerson:String?
    var headerDocumenetType:String?
    var headerCostSoruce:String?
    var HeaderEditable:Bool?
    var HeaderIsSynced:Bool?
    var headerCustomerCode:String?
    var syncId:String?
    var deleted:Bool?
    var headerImages:[Image]?
    var lines:[Line]?
    var isDraft:Bool?
    
    var customer:Customer?{
        if let _ = headerCustomerId{
            return DatabaseManagement.shared.queryCustomerById(customerid: headerCustomerId!)
        }
        return nil
    }
    
    var HeaderLines:[Line]{
        return DatabaseManagement.shared.queryheaderLines(headerid:id!)
    }
    
    var images:[Image]{
        return DatabaseManagement.shared.queryHeaderImages(headerid: id!)
    }
    
    init(id:Int64 ,headerUserId:Int64,headerCreatedDate:Date,headerPostedDate:Date,headerUpdateDate:Date?,headerExpensesType:String,headerCustomerId:Int64?,headerCustomerCode:String?,headerisApproved:ExpensesState,expaded:Bool = false,headerPhoneNumber:String?,headerBillingAddress:String?,headerShippingAddress:String?,headerContactPerson:String?,headerDocumenetType:String? = nil , headerEditable:Bool? = false,headerIsSynced:Bool?,headerCostSource:String,syncId:String?,deleted:Bool?,isDraft:Bool?) {
        
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
        self.headerCustomerCode = headerCustomerCode
        self.syncId = syncId
        self.deleted = deleted
        self.isDraft = isDraft
        super.init()
    }
    override init() {
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
         self.id = json["id"].int64
         self.headerUserId = json["headerUserId"].int64
        if let date = json["headerCreatedDate"].string {
            self.headerCreatedDate = DateHelper.getFormatedDateFromISOString(date)
        }
        if let date = json["headerPostedDate"].string{
            self.headerPostedDate = DateHelper.getFormatedDateFromISOString(date)
        }
        
         self.headerExpensesType = json["headerExpensesType"].string
         self.headerStatus = json["headerStatus"].int
         self.headerKey = json["headerKey"].string
         self.expaded = json["expaded"].bool
         self.headerPhoneNumber = json["headerPhoneNumber"].string
         self.headerBillingAddress = json["headerBillingAddress"].string
         self.headerShippingAddress = json["headerShippingAddress"].string
         self.headerContactPerson = json["headerContactPerson"].string
         self.headerDocumenetType = json["headerDocumenetType"].string
         self.HeaderIsSynced = json["HeaderIsSynced"].bool
         self.HeaderEditable = json["HeaderEditable"].bool
        if let date = json["headerUpdatedDate"].string{
            self.headerUpdatedDate = DateHelper.getFormatedDateFromISOString(date)
        }
         self.headerCostSoruce = json["headerCostSoruce"].string
        if let array = json["lines"].array{
            self.lines = array.map{Line(json: $0)}
        }
        if let array = json["images"].array{
            self.headerImages = array.map{Image(json: $0)}
        }
         self.syncId = json["SyncId"].string
         self.deleted = json["deleted"].bool
        self.isDraft = json["isDraft"].bool
    }
    
    public var description: String {
        return "id = \(self.id ?? 0), title = \(self.headerCreatedDate ?? Date()), Key = \(self.headerKey ?? "") \(self.headerExpensesType ?? "") \(self.headerStatus ?? -1)"
    }
    
    func save(){
        if id == -1{
        id = DatabaseManagement.shared.addHeader(header: self)!
        print("header")
        print(dictionaryRepresentation())
        print("================")
        }else{
            _ = DatabaseManagement.shared.updateHeader(id: id!, header: self)
            print("header")
            print(dictionaryRepresentation())
            print("================")
        }
    }
    
    func delete(){
        self.headerUpdatedDate = Date()
        self.deleted = true
        self.HeaderIsSynced = false
        self.save()
    }

    public  override func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary["id"] = self.id
        dictionary["headerUserId"] = "\(self.headerUserId!)"
        if let date = self.headerCreatedDate {
            dictionary["headerCreatedDate"] = DateHelper.getISOStringFromDate(date)
        }
        if let date = self.headerPostedDate{
            dictionary["headerPostedDate"] =  DateHelper.getISOStringFromDate(date)
        }
        if let value = self.headerExpensesType {
            dictionary["headerExpensesType"] = value == "Customer" ? "0" : "1"
        }
        dictionary["headerCustomerCode"] = self.headerCustomerCode
        if let value = self.headerStatus{
            dictionary["headerStatus"] = "\(value)"
        }
        dictionary["headerKey"] = self.headerKey
        dictionary["expaded"] = self.expaded ?? false
        dictionary["headerPhoneNumber"] = self.headerPhoneNumber
        dictionary["headerBillingAddress"] = self.headerBillingAddress
        dictionary["headerShippingAddress"] = self.headerShippingAddress
        dictionary["headerContactPerson"] = self.headerContactPerson
        dictionary["headerDocumenetType"] = "\(HeadrDocumentTypeValue(val:self.headerDocumenetType) ?? 0)"
        dictionary["HeaderIsSynced"] = "\(self.HeaderIsSynced ?? false)"
        dictionary["HeaderEditable"] = "\(self.HeaderEditable ?? false)"
        if let date = self.headerUpdatedDate{
            dictionary["headerUpdatedDate"] = DateHelper.getISOStringFromDate(date)
        }
        if let value = self.headerCostSoruce{
            dictionary["headerCostSoruce"] = value == "" ? "0" : value
        }
        dictionary["lines"] = HeaderLines.map{$0.dictionaryRepresentation()}
        dictionary["images"] = self.images.map{$0.dictionaryRepresentation()}
        dictionary["SyncId"] = syncId ?? "-1"
        dictionary["deleted"] = deleted ?? false
        dictionary["isDraft"] = isDraft ?? true
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
            return 0
        }
    }
    
}
