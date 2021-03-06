//
//  BaseModel.swift
//
//  Created by Molham Mahmoud on 25/04/16
//  Copyright (c) . All rights reserved.
//

import SwiftyJSON

/**
 a base model for all business objects in the app, offers comon members and methods among all models
 */
public class BaseModel {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kBaseModelIdKey: String = "baseId"

    // MARK: Properties
    
    public var baseId: String = ""
    
    init() {
    }
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public required init(json: JSON) {
        if let identefier = json[kBaseModelIdKey].string {
            baseId = identefier
        }
    }

    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[kBaseModelIdKey] = baseId
        return dictionary
    }
    
    func isEqual<T:BaseModel>(item:T) -> Bool {
        if item.baseId == self.baseId {
            return true
        }
        return false
    }
    
    // MARK: arrays utils
    func isExistIn<T:BaseModel>(arr:[T]) -> Bool {        
        if arr.contains(where: { $0.baseId == self.baseId }) {
            return true
        } else {
            return false
        }
    }
    
    func findObjectById<T:BaseModel>(arr:[T] , id: String) -> T? {
        let object = arr.filter{$0.baseId == baseId}.first
        return object
    }
    
    func removeObjectById<T:BaseModel>(arr:[T] , id: String) -> [T] {
        var result = arr
        if let index = arr.index(where: {$0.baseId == baseId}) {
            result.remove(at: index)
        }
        return result
    }
}
