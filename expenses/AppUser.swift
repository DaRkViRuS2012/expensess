//
//  User.swift
//  Wardah
//
//  Created by Dania on 6/12/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON


class AppUser: BaseModel {
    // MARK: Keys
    private let kUserFirstNameKey = "first_name"
    private let kUserLastNameKey = "last_name"
    private let kUserEmailKey = "email"
    private let kUserCountryKey = "country"
    private let kUserCategoriesKey = "categories"
    private let kUserAccountTypeKey = "type"
    private let kUserTokenKey = "token"
    private let kUserIdKey = "id"
    
    
    // MARK: Properties
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var profilePic: String?
    public var birthday: Date?
    public var country: String?
    public var isVerified: Bool?
    public var token: String?
    public var mobile:String?
    public var address:String?
    public var city:String?
    public var state:String?
    public var hongKong:String?
    public var UId:String?
    
    
    // user full name
    public var fullName: String {
        if let fName = firstName, !fName.isEmpty {
            if let lName = lastName, !lName.isEmpty {
                return  fName + " " + lName
            }
            return fName
        }
        return lastName ?? ""
    }
    
    // MARK: User initializer
    public override init(){
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        if let value = json[kUserIdKey].string{
            UId = value
        }else if let value = json[kUserIdKey].int{
            UId  = "\(value)"
        }
        firstName = json[kUserFirstNameKey].string
        lastName = json[kUserLastNameKey].string
        email = json[kUserEmailKey].string
        country = json[kUserCountryKey].string
        token = json[kUserTokenKey].string
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        if let value = UId{
            dictionary[kUserIdKey] = value
        }
        // first name
        if let value = firstName {
            dictionary[kUserFirstNameKey] = value
        }
        // last name
        if let value = lastName {
            dictionary[kUserLastNameKey] = value
        }
        // email
        if let value = email {
            dictionary[kUserEmailKey] = value
        }
        // country
        if let value = country {
            let url:[String:AnyObject] = ["url":value as AnyObject]
            let v:[String:AnyObject] = ["data":url as AnyObject]
            dictionary[kUserCountryKey] = v
        }
        // token
        if let value = token {
            dictionary[kUserTokenKey] = value
        }
        return dictionary
    }
    
}
