//
//  User.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation


class User :NSObject,NSCoding{
    
    var UserId:Int64
    var UserFirstName:String
    var UserLastName:String
    var UserName:String
    var UserImage:String
    var UserPWD:String
    var UserisActive:Bool
    var UserVendorCode:String?
    var UserEmail:String
    
    
    init(id:Int64 ,UserFirstName:String,UserLastName:String,UserEmail:String,UserName:String,UserImage:String,UserPWD:String,UserisActive:Bool,UserVendorCode:String?) {
        self.UserId = id
        self.UserFirstName = UserFirstName
        self.UserLastName = UserLastName
        self.UserEmail = UserEmail
        self.UserName = UserName
        self.UserImage = UserImage
        self.UserPWD = UserPWD
        self.UserisActive = UserisActive
        self.UserVendorCode = UserVendorCode
    }
    
    
    
    func save(){
        DatabaseManagement.shared.updateUser(id: self.UserId, user: self)
    
    }
    
    func getEmployeeItems() -> [Item]{
        let items = DatabaseManagement.shared.queryItems(type: "Employee", userid: self.UserId)
        return items
    
    }
    
    func getCustomerItems() -> [Item]{
        let items = DatabaseManagement.shared.queryItems(type: "Customer", userid: self.UserId)
        return items
        
    }
    
    
    func getEmployeeHeaders(date:Date,type:String)->[Header]{
    
        let headers = DatabaseManagement.shared.queryAllHeadersByDate(type: "Employee", date: date, userid: self.UserId, filterType: type)
        return headers
    }
    
    func getCustomerHeaders(date:Date,type:String)->[Header]{
        
        //let headers = DatabaseManagement.shared.queryAllHeaders(type: "Customer", userid: self.UserId)
        let headers = DatabaseManagement.shared.queryAllHeadersByDate(type: "Customer", date: date, userid: self.UserId, filterType: type)
        return headers
    }
    
    
    func getAllCustomerHeaders()->[Header]{
        
        let headers = DatabaseManagement.shared.queryAllHeaders(type: "Customer", userid: self.UserId)
        
        return headers
    }
    
    func getPrices()->[Price] {
    
        let prices = DatabaseManagement.shared.queryAllPrices(userid: self.UserId)
        return prices
    }
    
    func getCustomers()->[Customer]{
        
        let customers = DatabaseManagement.shared.queryAllCustomers(userid: self.UserId)
        return customers
    }
    
    func getUoM()->[UoM]{
    
        let UoMs = DatabaseManagement.shared.queryAllUoM(userid: self.UserId)
        return UoMs

    }

    
    func getCurrencies()->[Currency] {
    
        let currencies = DatabaseManagement.shared.queryAllCurrency(userid: self.UserId)
        return currencies
    }
    
    
  
    
    required public init(coder aDecoder: NSCoder) {
        UserId = aDecoder.decodeObject(forKey: "UserId") as! Int64
        UserFirstName = aDecoder.decodeObject(forKey: "UserFirstName") as! String
        UserLastName = aDecoder.decodeObject(forKey: "UserLastName") as! String
        UserName = aDecoder.decodeObject(forKey: "UserName") as! String
        UserImage = (aDecoder.decodeObject(forKey: "UserImage") as! String)
        UserPWD = (aDecoder.decodeObject(forKey: "UserPWD") as! String)
        UserisActive = (aDecoder.decodeObject(forKey: "UserisActive") as! Bool)
        UserVendorCode = aDecoder.decodeObject(forKey: "UserVendorCode") as? String
        UserEmail = (aDecoder.decodeObject(forKey: "UserEmail") as! String)
    }
    
    

    
    
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(UserId, forKey: "UserId")
        aCoder.encode(UserFirstName, forKey: "UserFirstName")
        aCoder.encode(UserLastName, forKey: "UserLastName")
        aCoder.encode(UserName, forKey: "UserName")
        aCoder.encode(UserImage, forKey: "UserImage")
        aCoder.encode(UserPWD, forKey: "UserPWD")
        aCoder.encode(UserisActive, forKey: "UserisActive")
        aCoder.encode(UserVendorCode, forKey: "UserVendorCode")
        aCoder.encode(UserEmail, forKey: "UserEmail")
    }
    
    
}
