//
//  DataStore.swift
//  
//
//  Created by AlphaApps on 14/11/16.
//  Copyright © 2016 BrainSocket. All rights reserved.
//

import SwiftyJSON

/**This class handle all data needed by view controllers and other app classes
 
 It deals with:
 - Userdefault for read/write cached data
 - Any other data sources e.g social provider, contacts manager, etc..
 **Usag:**
 - to write something to chach add constant key and a computed property accessors (set,get) and use the according method  (save,load)
 */
class DataStore :NSObject {
    
    //MARK: Cache keys
    private let CACHE_KEY_USER = "user"
    private let CACHE_KEY_CATEGORIES = "categories"
    private let CACHE_KEY_STORIES = "stories"
    private let CACHE_KEY_FEATURE = "feature"
    private let CACHE_KEY_CART = "cart"
    private let CACHE_KEY_PRODUCTS = "products"
    private let CACHE_KEY_SEARCH_PRODUCTS = "searchproducts"
    private let CACHE_KEY_LATEST_SEARCH_RESULTS = "latestSearchrResults"
    private let CACHE_KEY_TOKEN = "TOKEN"
    private let CACHE_KEY_DB = "DB"
    private let CACHE_KEY_ON_GOING_ORDER = "onGoingOrderId"
    //MARK: Temp data holders
    //keep reference to the written value in another private property just to prevent reading from cache each time you use this var
    private var _me:AppUser?
    private var _token:String?
    private var _company_db:String?
    
    
    var isOnGoingOrder = false{
        didSet{
            
        }
    }
    
    
    // user loggedin flag
    var isLoggedin: Bool {
        if let token = me?.token, !token.isEmpty {
            return true
        }
        return false
    }

//    var token:String = "ad2e844e-0956-4308-ad2e-d3ab133b2561"
  
    
    // MARK: Cached data
    public var me:AppUser?{
        set {
            _me = newValue
            saveBaseModelObject(object: _me, withKey: CACHE_KEY_USER)
            NotificationCenter.default.post(name: .notificationUserChanged, object: nil)
        }
        get {
            if (_me == nil) {
                _me = loadBaseModelObjectForKey(key: CACHE_KEY_USER)
            }
            return _me
        }
    }
    
    public var token:String?{
        set{
            _token = newValue
            saveStringWithKey(stringToStore: _token, key: CACHE_KEY_TOKEN)
        }
        get{
            _token = loadStringForKey(key: CACHE_KEY_TOKEN)
            return _token
        }
    }
    
    
    public var companyDB:String?{
        set{
            _company_db = newValue
            saveStringWithKey(stringToStore: _company_db, key: CACHE_KEY_DB)
        }
        get{
            _company_db = loadStringForKey(key: CACHE_KEY_DB)
            return _company_db
        }
    }
    
    func getItemsFromServer(){
        
        ApiManager.shared.getItems(userToken: token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
            }
        }
    }
    
    
    func getEmployeeItemsFromServer(){
        
        ApiManager.shared.getEmployeeItems(userToken: token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    
                    item.type = ItemType.employee.value
                    item.save()
                }
                
                
            }
        }
    }
    
    
    func getCurrenciesFromServer(){
        
        ApiManager.shared.getCurrency(userToken: token ?? "") { (success, error, result) in
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    
    
    func getUOMFromServer(){
        
        ApiManager.shared.getUOMs(userToken: token ?? "") { (success, error, result) in
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    
    
    
    func getCustomersFromServer(){
        
        ApiManager.shared.getCustomers(userToken: token ?? "") { (success, error, result) in
            if success{
                
                let items = result
                
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }
    
    
    
    func getPriceListFromServer(){
        
        ApiManager.shared.getPriceList(userToken: token ?? "") { (success, error, result) in
            if success{
                let items = result
                for item in items{
                    if let id = Globals.user?.UserId{
                        item.userid = id
                    }
                    item.save()
                }
                
                
            }
        }
    }

    func syncExpenses(){
        let customerHeaders =  Globals.user?.getAllCustomerHeaders().filter({$0.HeaderIsSynced == false}) ?? []
        let employeeHeaders =  Globals.user?.getAllEmployeesHeaders().filter({$0.HeaderIsSynced == false}) ?? []
        let allHeaders = customerHeaders + employeeHeaders
        
        let json = JSON(allHeaders.map{$0.dictionaryRepresentation()})
        if allHeaders.count > 0{
        ApiManager.shared.sendExpenses(userToken: token ?? "", content: json.rawString() ?? "") { (success, error, result) in
            if success{
                for res in result{
                    if let state = res.SyncResult,state == true{
                        if let header = allHeaders.first(where: {Int($0.id!) == res.ExpenseId}){
                                header.HeaderIsSynced = true
                                header.syncId = res.SyncId ?? "-1"
                                header.save()
                        }
                    }
                }
            }
            
            if error != nil{
                
            }
            }
    
        }
        
        
    }
    
    
    //MARK: Singelton
    public static var shared: DataStore = DataStore()
    
    private override init(){
        super.init()
    }
   
    //MARK: Cache Utils
    private func saveBaseModelArray(array: [BaseModel] , withKey key:String){
        let data : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func loadBaseModelArrayForKey<T:BaseModel>(key: String)->[T]{
        var result : [T] = []
        if let arr = UserDefaults.standard.array(forKey: key) as? [[String: Any]]
        {
            result = arr.map{T(json: JSON($0))}
        }
        return result
    }
    
    public func saveBaseModelObject<T:BaseModel>(object:T?, withKey key:String)
    {
        UserDefaults.standard.set(object?.dictionaryRepresentation(), forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func loadBaseModelObjectForKey<T:BaseModel>(key:String) -> T?
    {
        if let object = UserDefaults.standard.object(forKey: key)
        {
            return T(json: JSON(object))
        }
        return nil
    }
    
    private func loadStringForKey(key:String) -> String?{
        let storedString = UserDefaults.standard.object(forKey: key) as? String
        return storedString;
    }
    
    private func saveStringWithKey(stringToStore: String?, key: String){
        UserDefaults.standard.set(stringToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    private func loadIntForKey(key:String) -> Int{
        let storedInt = UserDefaults.standard.object(forKey: key) as? Int ?? 0
        return storedInt;
    }
    
    private func saveIntWithKey(intToStore: Int, key: String){
        UserDefaults.standard.set(intToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func clearCache()
    {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }

    public func saveUser(notify: Bool) {
        saveBaseModelObject(object: _me, withKey: CACHE_KEY_USER)
        if notify {
            NotificationCenter.default.post(name: .notificationUserChanged, object: nil)
        }
    }
    
  
    public func logout() {
        clearCache()
        me = nil
        token = nil
        Globals.user = nil
        Globals.isLogedin = false
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        ActionShowStart.execute()
    }
}





