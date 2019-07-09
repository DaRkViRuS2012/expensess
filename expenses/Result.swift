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
    public var value : String?
	public var xML_data : String?
	public var invalidSession : Bool?
	public var documentNumber : Int?

    
    public required init(json: JSON) {
        super.init(json: json)
        has_Error = json["Has_Error"].bool
        error_Message = json["Error_Message"].string
        if let array = json["Resault_Value"].array{
            resault_Value =  array.map{T(json:$0)}
        }
        value = json["Resault_Value"].string
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
