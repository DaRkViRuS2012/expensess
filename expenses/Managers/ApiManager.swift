//
//  ApiManager.swift
//
//  Created by Molham Mahmoud on 25/04/16.
//  Copyright © 2016. All rights reserved.
//

import SwiftyJSON
import Alamofire
import CoreLocation

/// - Api store do all Networking stuff
///     - build server request 
///     - prepare params
///     - and add requests headers
///     - parse Json response to App data models
///     - parse error code to Server error object
///


enum ModelType {
    case customer //: 2
    case currency//: 27
    case uom//: 100001
    case priceList//: 100002
    case item//: 4
    
    var value:String{
        switch self {
        case .customer:
            return "oBusinessPartners"
        case .currency:
            return "oCurrencyCodes"
        case .uom:
            return "oUOMs"
        case .priceList:
            return "oPriceList"
        case .item:
            return "oItems"
            
        }
    }
    
}

class ApiManager: NSObject {

    typealias Payload = (MultipartFormData) -> Void
    
    /// frequent request headers
    var headers: HTTPHeaders{
        get{
            let token = ((DataStore.shared.me?.token) != nil) ? "Bearer \((DataStore.shared.me?.token)!)" : ""
            let httpHeaders = [
                "Authorization": token,
                "Accept":"application/json"
            ]
            return httpHeaders
        }
    }
    
    let baseURL = "https://ms.itmd-b1.com:65511/API"
    //let baseURL = "http://192.168.1.116:8000/api"
//    let imageUrl = "http://anycubed.net"
//    let error_domain = "Wardah"
    
    //MARK: Shared Instance
    static let shared: ApiManager = ApiManager()
    
    private override init(){
        super.init()
    }    
   
    // MARK: Authorization

    /// User login request
    func userLogin(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/login"
        let parameters : [String : Any] = [
            "email": email,
            "password": password
        ]
        
        
        print(signInURL)
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse)
                    DataStore.shared.me = user
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                 if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                 } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    
    
    /// User Signup request
    func userSignup(user: AppUser, password: String,image:UIImage?, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        guard password.length>0,
            let _ = user.email
            else {
                return
        }
        
        let signUpURL = "\(baseURL)/register"
        
        var parameters : [String : Any] = [
            "email": user.email!,
            "password": password,
            "phone_number": user.mobile!,
            "first_name":user.firstName!,
            "last_name":user.lastName!
        ]
        
        if let bDate = user.birthday {
            let bDateString = DateHelper.getISOStringFromDate(bDate)
            parameters["birth_date"] = bDateString!
        }
        
        if let _ = image{
        let payload : Payload = { multipartFormData in
            
            if let photo = image, let imageData = UIImageJPEGRepresentation(photo, 0.1){
                multipartFormData.append(imageData, withName: "hk_id", fileName: "file.jpg", mimeType: "image/jpg")
                
            }
            
            for (key, value) in parameters{
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }
        
        Alamofire.upload(multipartFormData: payload, to: signUpURL, method: .post, headers: headers,
                         encodingCompletion: { encodingResult in
                            print(encodingResult)
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { responseObject in
                                    
                                    //Request success
                                    if responseObject.result.isSuccess {
                                        let jsonResponse = JSON(responseObject.result.value!)
                            if let code = responseObject.response?.statusCode, code >= 400 {
                                            let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                                            completionBlock(false , serverError, nil)
                                        } else {
                                            //parse user object and save it
                                            let user = AppUser(json: jsonResponse)
                                            DataStore.shared.me = user
                                            completionBlock(true , nil,user)
                                        }
                                    }
                                    //Network error
                                    if responseObject.result.isFailure {
                                        if let code = responseObject.response?.statusCode, code >= 400 {
                                            completionBlock(false, ServerError.unknownError, nil)
                                        } else {
                                            completionBlock(false, ServerError.connectionError, nil)
                                        }
                                    }
                                }
                            case .failure(let encodingError):
                                completionBlock(false, ServerError.unknownError,nil)
                            }
        })
        }
        else{
        // build request
        Alamofire.request(signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
//                    let user = AppUser(json: jsonResponse["user"])
//                    DataStore.shared.me = user
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
            }
            
        }
    }
    
    
    
   
    //  getItems
    func getItems(userToken:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ response:[Item]) -> Void) {
        let categoriesListURL = "\(baseURL)/Get/GetData?userToken=\(userToken)&moduleId=\(ModelType.item.value)"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                // let resJson = JSON(responseObject.result.value!)

                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError,[])
                } else {
                    let resultObject = Result<Item>(json:jsonResponse)
                    if let haserror = resultObject.has_Error,!haserror {
                        let result = resultObject.resault_Value
                        completionBlock(true, nil,result!)
                    }else{
                        completionBlock(false, ServerError.unknownError,[])
                    }

                }
            }
            if responseObject.result.isFailure {

                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,[])
                } else {
                    completionBlock(false, ServerError.connectionError,[])
                }
            }
        }
    }

    
    
    // get customers
    func getCustomers(userToken:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ response:[Customer]) -> Void) {
        let categoriesListURL = "\(baseURL)/Get/GetData?userToken=\(userToken)&moduleId=\(ModelType.customer.value)"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                // let resJson = JSON(responseObject.result.value!)
                
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError,[])
                } else {
                    let resultObject = Result<Customer>(json:jsonResponse)
                    if let haserror = resultObject.has_Error,!haserror {
                        let result = resultObject.resault_Value
                        completionBlock(true, nil,result!)
                    }else{
                        completionBlock(false, ServerError.unknownError,[])
                    }
                    
                }
            }
            if responseObject.result.isFailure {
                
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,[])
                } else {
                    completionBlock(false, ServerError.connectionError,[])
                }
            }
        }
    }
    
    
    
    
    // get currency
    func getCurrency(userToken:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ response:[Currency]) -> Void) {
        let categoriesListURL = "\(baseURL)/Get/GetData?userToken=\(userToken)&moduleId=\(ModelType.currency.value)"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                // let resJson = JSON(responseObject.result.value!)
                
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError,[])
                } else {
                    let resultObject = Result<Currency>(json:jsonResponse)
                    if let haserror = resultObject.has_Error,!haserror {
                        let result = resultObject.resault_Value
                        completionBlock(true, nil,result!)
                    }else{
                        completionBlock(false, ServerError.unknownError,[])
                    }
                    
                }
            }
            if responseObject.result.isFailure {
                
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,[])
                } else {
                    completionBlock(false, ServerError.connectionError,[])
                }
            }
        }
    }
    
    
    // get UOMs
    func getUOMs(userToken:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ response:[UoM]) -> Void) {
        let categoriesListURL = "\(baseURL)/Get/GetData?userToken=\(userToken)&moduleId=\(ModelType.uom.value)"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                // let resJson = JSON(responseObject.result.value!)
                
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError,[])
                } else {
                    let resultObject = Result<UoM>(json:jsonResponse)
                    if let haserror = resultObject.has_Error,!haserror {
                        let result = resultObject.resault_Value
                        completionBlock(true, nil,result!)
                    }else{
                        completionBlock(false, ServerError.unknownError,[])
                    }
                    
                }
            }
            if responseObject.result.isFailure {
                
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,[])
                } else {
                    completionBlock(false, ServerError.connectionError,[])
                }
            }
        }
    }
    
    
    
    // get PriceList
    func getPriceList(userToken:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ response:[Price]) -> Void) {
        let categoriesListURL = "\(baseURL)/Get/GetData?userToken=\(userToken)&moduleId=\(ModelType.priceList.value)"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                // let resJson = JSON(responseObject.result.value!)
                
                let jsonResponse = JSON(responseObject.result.value!)
                print(jsonResponse)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError,[])
                } else {
                    let resultObject = Result<Price>(json:jsonResponse)
                    if let haserror = resultObject.has_Error,!haserror {
                        let result = resultObject.resault_Value
                        completionBlock(true, nil,result!)
                    }else{
                        completionBlock(false, ServerError.unknownError,[])
                    }
                    
                }
            }
            if responseObject.result.isFailure {
                
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,[])
                } else {
                    completionBlock(false, ServerError.connectionError,[])
                }
            }
        }
    }


}

/**
 Server error represents custome errors types from back end
 */
struct ServerError {
    
    static let errorCodeConnection = 50
    
    public var errorName:String?
    public var status: Int?
    public var code:Int!
    
    public var type:ErrorType {
        get{
            return  .unknown //ErrorType(rawValue: code) ?? .unknown
        }
    }
    
    /// Server erros codes meaning according to backend
    enum ErrorType:Int {
        case connection = 50
        case unknown = -111
        case authorization = 900
        case alreadyExists = 101
        case socialLoginFailed = -110
		case notRegistred = 102
        case missingInputData = 104
        case expiredVerifyCode = 107
        case invalidVerifyCode = 108
        case userNotFound = 109
        
        /// Handle generic error messages
        /// **Warning:** it is not localized string
        var errorMessage:String {
            switch(self) {
                case .unknown:
                    return "ERROR_UNKNOWN".localized
                case .connection:
                    return "ERROR_NO_CONNECTION".localized
                case .authorization:
                    return "ERROR_NOT_AUTHORIZED".localized
                case .alreadyExists:
                    return "ERROR_SIGNUP_EMAIL_EXISTS".localized
				case .notRegistred:
                    return "ERROR_SIGNIN_WRONG_CREDIST".localized
                case .missingInputData:
                    return "ERROR_MISSING_INPUT_DATA".localized
                case .expiredVerifyCode:
                    return "ERROR_EXPIRED_VERIFY_CODE".localized
                case .invalidVerifyCode:
                    return "ERROR_INVALID_VERIFY_CODE".localized
                case .userNotFound:
                    return "ERROR_RESET_WRONG_EMAIL".localized
                default:
                    return "ERROR_UNKNOWN".localized
            }
        }
    }
    
    public static var connectionError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.connection.rawValue
            return error
        }
    }
    
    public static var unknownError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.unknown.rawValue
            return error
        }
    }
    
    public static var socialLoginError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.socialLoginFailed.rawValue
            return error
        }
    }
    
    public init() {
    }
    
    public init?(json: JSON) {
//        guard let errorCode = json["code"].int else {
//            return nil
//        }
//        code = errorCode
        errorName = ""
        if let errorArray = json["error:"].array{
            for error in errorArray{
                errorName?.append("\n\(error)")
            }
        }
        
        if let errorArray = json["error"].array{
            for error in errorArray{
                if let msg = error.rawString(){
                    errorName?.append("\n\(msg)")
                    
                }
            }
        }
        
     
        
        if let statusCode = json["status"].int{ status = statusCode}
    }
}


