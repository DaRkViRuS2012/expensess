/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 import SwiftyJSON
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Result<T:BaseModel>:BaseModel{
	public var has_Error : Bool?
	public var error_Message : String?
	public var resault_Value : Array<T>?
	public var xML_data : String?
	public var invalidSession : Bool?
	public var documentNumber : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:[JSON]) -> [Result<T>]
    {
        var models:[Result<T>] = []
        for item in array
        {
            models.append(Result<T>(json: item))
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {
        super.init()
		has_Error = dictionary["Has_Error"] as? Bool
		error_Message = dictionary["Error_Message"] as? String
//        if (dictionary["Resault_Value"] != nil) { resault_Value = T.modelsFromDictionaryArray(dictionary["Resault_Value"] as! NSArray) }
		xML_data = dictionary["XML_data"] as? String
		invalidSession = dictionary["InvalidSession"] as? Bool
		documentNumber = dictionary["DocumentNumber"] as? Int
	}
    
    public required init(json: JSON) {
        super.init(json: json)
        has_Error = json["Has_Error"].bool
        error_Message = json["Error_Message"].string
        if let array = json["Resault_Value"].array{
            resault_Value =  array.map{T(json:$0)}
        }
        xML_data = json["XML_data"].string
        invalidSession = json["InvalidSession"].bool
        documentNumber = json["DocumentNumber"].int
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
