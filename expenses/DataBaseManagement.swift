






import Foundation
import SQLite

class DatabaseManagement {
    
    
    static let shared:DatabaseManagement = DatabaseManagement()
    
    
    private let db: Connection?
    

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            createTableItems()
            createTableHeader()
            createTableLine()
            createTableUser()
            createTableImage()
            createTablePriceList()
            createTableCustomerList()
            createTableSetup()
            createTableUoM()
            createTableCurrency()
            do{
                try db?.run(tblDocumentType.drop())
            }catch{
            
            }
            createTableDocumentType()
            
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }

 
    /////////////// Header ///////////
    
    
    private let tblHeader = Table("Header")
    private let Headerid = Expression<Int64>("id")
    private let headerUserId = Expression<Int64>("UserId")
    private let headerKey = Expression<String?>("Key")
    private let headerSyncId = Expression<String?>("SyncId")
    private let headerCreatedDate = Expression<Date>("CreatedDate")
    private let headerPostedDate = Expression<Date>("PostedDate")
    private let headerExpensesType = Expression<String>("ExpensesType")
    private let headerDocumnetType = Expression<String?>("DocumnetType")
    private let headerCustomerId = Expression<Int64?>("CustomerId")
    private let headerCustomerCode = Expression<String?>("CustomerCode")
    private let headerisApproved = Expression<Int>("isApproved")
    private let headerPhoneNumber = Expression<String?>("PhoneNumber")
    private let headerBillingAddress = Expression<String?>("BillingAddress")
    private let headerShippingAddress = Expression<String?>("ShippingAddress")
    private let headerContactPerson = Expression<String?>("ContactPerson")
    private let headerIsSynced = Expression<Bool>("isSynced")
    private let headerIsDeleted = Expression<Bool>("isDeleted")
    
    
    func createTableHeader() {
        do {
            try db!.run(tblHeader.create(ifNotExists: false) { table in
                table.column(Headerid, primaryKey: true)
                table.column(headerUserId, references: tblUser,UserId)
                table.column(headerKey ,unique: true)
                table.column(headerCreatedDate)
                table.column(headerPostedDate)
                table.column(headerExpensesType)
                table.column(headerDocumnetType)
                table.column(headerCustomerId,references:tblCustomerList,customerId)
                table.column(headerCustomerCode)
                table.column(headerisApproved)
                table.column(headerPhoneNumber)
                table.column(headerBillingAddress)
                table.column(headerShippingAddress)
                table.column(headerContactPerson)
                table.column(headerSyncId)
                table.column(headerIsSynced)
                table.column(headerIsDeleted)
            })
            print("create Header table successfully")
        } catch {
            print("Unable to create Header table")
        }
    }
    
    
    func addHeader(header:Header) -> Int64? {
        do {
            let insert = tblHeader.insert(headerUserId <- header.headerUserId,headerCreatedDate <- header.headerCreatedDate!,headerPostedDate <- header.headerPostedDate! , headerExpensesType <- header.headerExpensesType! ,headerCustomerId <- header.headerCustomerId , headerisApproved <- header.headerStatus! ,headerPhoneNumber <- header.headerPhoneNumber,headerBillingAddress <- header.headerBillingAddress , headerShippingAddress <- header.headerShippingAddress,headerContactPerson <- header.headerContactPerson, headerDocumnetType <- header.headerDocumenetType,headerCustomerCode <- header.headerCustomerCode,headerSyncId <- header.syncId,headerIsSynced <- header.HeaderIsSynced ?? false, headerIsDeleted <- header.deleted ?? false)
            let id = try db!.run(insert)
            
            let header = tblHeader.filter(headerId == id)
            try db!.run(header.update(headerKey <- "\(header[headerUserId])\(id)"))
            print("Insert to tblHeader successfully userid \(headerUserId)")
            return id
        } catch {
            print("Cannot insert to tblHeader ")
            print(error)
            return nil
        }
    }
    
    
    
    
    
    
    func addHeader(headeruserId:Int64,headercreatedDate:Date,headerpostedDate:Date,headerexpensesType:String,headercustomerCode:String?,headerisapproved:Int,customerCode:String) -> Int64? {
        do {
            let insert = tblHeader.insert(headerUserId <- headeruserId,headerCreatedDate <- headercreatedDate,headerPostedDate <- headerpostedDate , headerExpensesType <- headerexpensesType ,headerCustomerId <- headerCustomerId , headerisApproved <- headerisapproved,headerCustomerCode <- customerCode )
            let id = try db!.run(insert)
            
            let header = tblHeader.filter(Headerid == id)
            try db!.run(header.update(headerKey <- "\(header[headerUserId])\(id)"))
            print("Insert to tblHeader successfully userid \(headeruserId)")
            return id
        } catch {
            print("Cannot insert to tblHeader ")
            print(error)
            return nil
        }
    }
    
    
    func findHeader(date:Date,type:String)->Int64?{
    
        do{
            let header = try tblHeader.filter(headerPostedDate == date && headerExpensesType == type)
            let headerid = try db!.pluck(header)
            let id = headerid?[headerId]
          
                return id
          
        }catch{
            return nil
        }
        
    
    
    }
    
    
    func queryAllHeaders(type:String,userid:Int64) -> [Header] {
        var headers = [Header]()
        
        do {
            for header in try db!.prepare(self.tblHeader.filter(headerExpensesType == type && headerUserId == userid)) {
                
                let state = ExpensesState(rawValue: header[headerisApproved])
                let newheader = Header(id: header[Headerid], headerUserId: header[headerUserId], headerCreatedDate: header[headerCreatedDate], headerPostedDate: header[headerPostedDate], headerUpdateDate: Date(), headerExpensesType: header[headerExpensesType], headerCustomerId: header[headerCustomerId], headerCustomerCode: header[headerCustomerCode], headerisApproved: state!,headerPhoneNumber:header[headerPhoneNumber],headerBillingAddress:header[headerBillingAddress],headerShippingAddress:header[headerShippingAddress],headerContactPerson:header[headerContactPerson],headerDocumenetType:header[headerDocumnetType], headerIsSynced: header[headerIsSynced], headerCostSource: "", syncId: header[headerSyncId], deleted: header[headerIsDeleted])
                headers.append(newheader)
            }
        } catch {
            print("Cannot get list of product")
        }
        for header in headers {
            print("each product = \(header)")
        }
        return headers
    }

    
    func queryAllHeadersByDate(type:String,date:Date,userid:Int64,filterType:String) -> [Header] {
        var headers = [Header]()
        
        do {
            
        
            for header in try db!.prepare(self.tblHeader.filter(headerExpensesType == type && headerUserId == userid)) {
                var currentDate =  DateHelper.getMonthStringFromShortDate(date)
                var headerdate = DateHelper.getMonthStringFromShortDate(header[headerCreatedDate])
                if filterType == "Yearly"{
                    currentDate =  DateHelper.getYearStringFromShortDate(date)
                     headerdate = DateHelper.getYearStringFromShortDate(header[headerCreatedDate])
                }
                if currentDate == headerdate {
                let state = ExpensesState(rawValue: header[headerisApproved])
                    let newheader = Header(id: header[Headerid], headerUserId: header[headerUserId], headerCreatedDate: header[headerCreatedDate], headerPostedDate: header[headerPostedDate], headerUpdateDate: Date(), headerExpensesType: header[headerExpensesType], headerCustomerId: header[headerCustomerId], headerCustomerCode: header[headerCustomerCode], headerisApproved: state!,headerPhoneNumber:header[headerPhoneNumber],headerBillingAddress:header[headerBillingAddress],headerShippingAddress:header[headerShippingAddress],headerContactPerson:header[headerContactPerson],headerDocumenetType:header[headerDocumnetType], headerIsSynced: header[headerIsSynced], headerCostSource: "", syncId: header[headerSyncId], deleted: header[headerIsDeleted])
                    headers.append(newheader)
                }
            }
        } catch {
            print("Cannot get list of product")
        }
        for header in headers {
            print("each product = \(header)")
        }
        return headers
    }

    
    
    func queryHeaderById(id:Int64) -> Header? {
        do{
            let headerid  = tblHeader.filter(Headerid == id)
            let header  = try db!.pluck(headerid)
            let state = ExpensesState(rawValue: (header?[headerisApproved])!)
            let newheader = Header(id: (header?[Headerid])!, headerUserId: (header?[headerUserId])!, headerCreatedDate: (header?[headerCreatedDate])!, headerPostedDate: (header?[headerPostedDate])!, headerUpdateDate: Date(), headerExpensesType: (header?[headerExpensesType])!, headerCustomerId: header?[headerCustomerId], headerCustomerCode: header?[headerCustomerCode], headerisApproved: state!,headerPhoneNumber:header?[headerPhoneNumber],headerBillingAddress:header?[headerBillingAddress],headerShippingAddress:header?[headerShippingAddress],headerContactPerson:header?[headerContactPerson],headerDocumenetType:header?[headerDocumnetType], headerIsSynced: header?[headerIsSynced], headerCostSource: "", syncId: header?[headerSyncId], deleted: header?[headerIsDeleted])
            return newheader
        }catch{
            return nil
        }
        
    }
    
    
    
    func updateHeader(id:Int64, header: Header) -> Bool {
        let headertbl = tblHeader.filter(Headerid == id)
        do {
            let update = headertbl.update([
                headerUserId <- header.headerUserId,headerCreatedDate <- header.headerCreatedDate!,headerPostedDate <- header.headerPostedDate! , headerExpensesType <- header.headerExpensesType! ,headerCustomerId <- header.headerCustomerId , headerisApproved <- header.headerStatus! ,headerPhoneNumber <- header.headerPhoneNumber,headerBillingAddress <- header.headerBillingAddress , headerShippingAddress <- header.headerShippingAddress,headerContactPerson <- header.headerContactPerson , headerDocumnetType <- header.headerDocumenetType,headerCustomerCode <- header.headerCustomerCode,headerSyncId <- header.syncId,headerIsSynced <- header.HeaderIsSynced ?? false,headerIsDeleted <- header.deleted ?? false
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deleteHeader(Id: Int64) -> Bool {
        do {
            let tblFilterHeader = tblHeader.filter(Headerid == Id)
            try db!.run(tblFilterHeader.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    
    ///////////////// End Of Header //////////
    
    ///////////////// USER //////////////////
    
    //Mark: Users
    
    private let tblUser = Table("User")
    private let UserId = Expression<Int64>("id")
    private let UserFirstName = Expression<String>("FirstName")
    private let UserLastName = Expression<String>("LastName")
    private let UserEmail = Expression<String>("Email")
    private let UserName = Expression<String>("UserName")
    private let UserImage = Expression<String?>("Image")
    private let UserPWD = Expression<String>("Password")
    private let UserisActive = Expression<Bool>("isActive")
    private let UserVendorCode = Expression<String?>("VendorCode")
    
    
    
    
    func createTableUser() {
        do {
            try db!.run(tblUser.create(ifNotExists: false) { table in
                table.column(UserId, primaryKey: true)
                table.column(UserFirstName)
                table.column(UserLastName)
                table.column(UserName,unique: true)
                table.column(UserImage)
                table.column(UserPWD)
                table.column(UserisActive)
                table.column(UserVendorCode)
                table.column(UserEmail)
            })
            print("create User table successfully")
        } catch {
            print("Unable to create User table")
        }
    }
    
    func addUser(user:User) -> Int64? {
        do {
            let insert = tblUser.insert(UserFirstName <- user.UserFirstName,UserLastName <- user.UserLastName,UserEmail <- user.UserEmail,UserName <- user.UserName , UserImage <- user.UserImage
                ,UserPWD <- user.UserPWD , UserisActive <- user.UserisActive )
            let id = try db!.run(insert)
            print("Insert to tblUser successfully")
            return id
        } catch {
            print("Cannot insert to tblUser ")
            print(error)
            return nil
        }
    }
    
    func queryUserById(id:Int64) -> User? {
        do{
            let userid  = try tblUser.filter(UserId == id)
            let user  = try db!.pluck(userid)
            let newuser = User(id: (user?[UserId])!, UserFirstName: (user?[UserName])!, UserLastName: (user?[UserLastName])!,UserEmail:(user?[UserEmail])!, UserName: (user?[UserName])!, UserImage: (user?[UserImage]!)!, UserPWD: (user?[UserPWD])!, UserisActive: (user?[UserisActive])!, UserVendorCode: user?[UserVendorCode])
            return newuser
        }catch{
            return nil
        }
        
    }
    
    
    func queryUserbyNameandPass(username:String,pass:String) ->User?{
    
        
        do{
            let userid  =  tblUser.filter(UserName == username && UserPWD == pass)
          
            if  let user  = try db?.pluck(userid){
                let newuser =  User(id: (user[UserId]), UserFirstName: (user[UserName]), UserLastName: (user[UserLastName]),UserEmail:user[UserEmail], UserName: (user[UserName]), UserImage: (user[UserImage]!), UserPWD: (user[UserPWD]), UserisActive: (user[UserisActive]), UserVendorCode: user[UserVendorCode])
                    return newuser
                }else{
            return nil
            }
        }catch{
            return nil
        }
    }
    
    
    
    func updateUser(id:Int64, user: User) -> Bool {
        let Usertbl = tblUser.filter(UserId == id)
        do {
            let update = Usertbl.update([
                UserFirstName <- user.UserFirstName,UserLastName <- user.UserLastName,UserEmail <- user.UserEmail,UserName <- user.UserName , UserImage <- user.UserImage
                ,UserPWD <- user.UserPWD , UserisActive <- user.UserisActive
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
//    func login(username:String,pass:String)-> Bool{
//        
//        
//    
//    }
    
    
    
    //////////// End of User //////////////
    
    //////// Lines //////////////
    
//    
//    Header key ( point 3)
//    Line nr
//    Expense item ( filtered according to the previously selected expense header type point 8 )
//    Qty
//    Unit of measurement
//    Amount ( if Expense type is Customer expense , the amount is according to the below price list , it is a employee expense then it is empty )
//    Currency ( default according to the customer currency )
//    Array of scanned images
    
    
    
    private let tblLine = Table("Line")
    private let Lineid = Expression<Int64>("id")
    private let headerId = Expression<Int64>("headerid")
    private let LineUserId = Expression<Int64>("UserId")
    private let Qty = Expression<Double>("Qty")
    private let Amount = Expression<Double>("Amount")
    private let LineCurrency = Expression<String>("currency")
    private let ItemDiscription = Expression<String>("ItemDiscription")
    private let LinePrice = Expression<Double>("Price")
    private let LineItem = Expression<Int64>("itemId")
    private let LineItemCode = Expression<String>("itemCode")
    private let LineUoM = Expression<String>("UoM")
    
    func createTableLine() {
        do {
            try db!.run(tblLine.create(ifNotExists: false) { table in
                table.column(Lineid, primaryKey: true)
                table.column(headerId,references:tblHeader,Headerid)
                table.column(Qty)
                table.column(Amount)
                table.column(LineCurrency)
                table.column(LinePrice)
                table.column(ItemDiscription)
                table.column(LineItem,references:tblItems,Itemid)
                table.column(LineItemCode)
                table.column(LineUoM)
                table.column(LineUserId, references: tblUser,UserId)
            })
            print("create Line table successfully")
        } catch {
            print("Unable to create Line table")
            print(error)
        }
    }
    
    
    
    func addLine(line:Line) -> Int64? {
        do {
            let insert = tblLine.insert(headerId <- line.headerId, Qty <- line.Qty,Amount <- line.Amount,LineCurrency <- line.currency , LinePrice <- line.LinePrice
                ,ItemDiscription <- line.ItemDiscription , LineItem <- line.ItemId, LineUoM <- line.LineUoM,LineUserId <- line.userid,LineItemCode <- line.ItemCode)
            let id = try db!.run(insert)
            print("Insert to tblLine successfully")
            return id
        } catch {
            print("Cannot insert to tblLine ")
            print(error)
            return nil
        }
    }
    
    
    func queryLineById(id:Int64) -> Line? {
        do{
            let linetbl  = tblLine.filter(Lineid == id)
            let line  = try db?.pluck(linetbl)
            let newline = Line(Lineid: (line?[Lineid])!, headerId: (line?[headerId])!, Qty: (line?[Qty])!, Amount: (line?[Amount])!, currency: (line?[LineCurrency])!, ItemDiscription: (line?[ItemDiscription])!, LinePrice: (line?[LinePrice])!, ItemId: (line?[LineItem])!, itemCode: line?[LineItemCode] ?? "",Lineuom:(line?[LineUoM])!,userid:(line?[LineUserId])!)
            return newline
        }catch{
            return nil
        }
        
    }
    
//    func addLine(headerid:Int64,qty:Double,amount:Double,currency:String,price:Double,disc:String,lineItem:Int64,uom:String, userid:Int64) -> Int64? {
//        do {
//            let insert = tblLine.insert(headerId <- headerid, Qty <- qty,Amount <- amount,LineCurrency <- currency , LinePrice <- price
//                ,ItemDiscription <- disc , LineItem <- lineItem, LineUoM <- uom,LineUserId <- userid)
//            let id = try db!.run(insert)
//            print("Insert to tblLine successfully")
//            return id
//        } catch {
//            print("Cannot insert to tblLine ")
//            print(error)
//            return nil
//        }
//    }
    
    func queryheaderLines(headerid:Int64)->[Line]{
        var lines:[Line] = []
            do {
                for line in try db!.prepare(self.tblLine.filter(headerId == headerid)) {
                    let newline = Line(Lineid: line[Lineid], headerId: line[headerId], Qty: line[Qty], Amount: line[Amount], currency: line[LineCurrency], ItemDiscription: line[ItemDiscription], LinePrice: line[LinePrice], ItemId: line[LineItem], itemCode: line[LineItemCode],Lineuom:line[LineUoM],userid:line[LineUserId])
                    lines.append(newline)
                }
            } catch {
                print("Cannot get list of product")
                
            }
            return lines
    }
    
    
    
    func updateLine(id:Int64, line: Line) -> Bool {
        let linetbl = tblLine.filter(Lineid == id)
        do {
            let update = linetbl.update([
                headerId <- line.headerId, Qty <- line.Qty,Amount <- line.Amount,LineCurrency <- line.currency , LinePrice <- line.LinePrice
                ,ItemDiscription <- line.ItemDiscription , LineItem <- line.ItemId, LineUoM <- line.LineUoM,LineUserId <- line.userid
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deleteLine(Id: Int64) -> Bool {
        do {
            let tblFilterLine = tblLine.filter(Lineid == Id)
            try db!.run(tblFilterLine.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    
    
    
    ///////////// End of Lines ////////
    
    
    
    
    /// / / / / / //////// Items /////////
    private let tblItems = Table("Items")
    private let Itemid = Expression<Int64>("id")
    private let ItemUserId = Expression<Int64>("UserId")
    private let ItemCode = Expression<String?>("ItemCode")
    private let ItemExpensesCode = Expression<String?>("ExpensesCode")
    private let Itemtype = Expression<String>("Itemtype")
    private let ItemIcon = Expression<String?>("ItemIcon")
    private let ItemUoMid = Expression<String?>("UoMId")
    private let ItemPrice = Expression<String?>("Price")
    private let ItemTitle = Expression<String?>("ItemTitle")
  //  private let ItemLineId = Expression<Int64>("LineId")
    
    func createTableItems() {
        do {
            try db!.run(tblItems.create(ifNotExists: false) { table in
                table.column(Itemid,primaryKey: true)
                table.column(ItemCode,unique: true)
                table.column(ItemTitle,unique: true)
                table.column(Itemtype)
                table.column(ItemIcon)
                table.column(ItemPrice)
                table.column(ItemExpensesCode)
                table.column(ItemUoMid)//,references:tblUoM,UomId)
                table.column(ItemUserId, references: tblUser,UserId)
              //  table.column(ItemLineId,references:tblLine,Lineid)
            })
            print("create Items table successfully")
        } catch {
            print("Unable to create Items table")
        }
    }
    
    
    
    
    func addItem(item:Item) -> Int64? {
        do {
            if let code = item.code{
                if let item = queryItemBy(code: code){
                    return item.Itemid
                }
            }
            let insert = tblItems.insert(or: .ignore,ItemCode <- item.code, Itemtype <- item.type!,ItemIcon <- item.icon, ItemUoMid <- item.UoM ,ItemPrice <- item.price , ItemTitle <- item.title , ItemUserId <- item.userid,ItemExpensesCode <- item.itemCode)
            let id = try db!.run(insert)
            print("Insert to tblItems successfully")
            return id
        } catch {
            print("Cannot insert to database")
            print(error)
            return nil
        }
    }
    
    func addItem(code:String,itemtitle:String,type:String,icon:String,price:String,UoM:String,userid:Int64) -> Int64? {
        do {
            let insert = tblItems.insert(ItemCode <- code, Itemtype <- type,ItemIcon <- icon, ItemUoMid <- UoM ,ItemPrice <- price , ItemTitle <- itemtitle , ItemUserId <- userid )
            let id = try db!.run(insert)
            print("Insert to tblItems successfully")
            return id
        } catch {
            print("Cannot insert to database")
            print(error)
            return nil
        }
    }
    
    func queryAllItems(userid:Int64) -> [Item] {
        var Items = [Item]()
        
        do {
            for item in try db!.prepare(self.tblItems.filter(ItemUserId == userid)) {
                let newitem = Item(id: item[Itemid] , code: item[ItemCode], type: item[Itemtype],  title: item[ItemTitle], price: item[ItemPrice], icon: item[ItemIcon], UoM: item[ItemUoMid]!,userid: item[ItemUserId],itemCode: item[ItemExpensesCode])
                Items.append(newitem)
            }
        } catch {
            print("Cannot get list of product")
        }
        for item in Items {
            print("each product = \(item)")
        }
        return Items
    }
    
    
    
    func queryItems(type:String,userid:Int64) -> [Item] {
        var Items = [Item]()
        
        do {
            
            for item in try db!.prepare(self.tblItems.filter(Itemtype == type && ItemUserId == userid)) {
                let newitem = Item(id: item[Itemid] , code: item[ItemCode], type: item[Itemtype], title: item[ItemTitle], price: item[ItemPrice], icon: item[ItemIcon], UoM: item[ItemUoMid],userid: item[ItemUserId],itemCode: item[ItemExpensesCode])
                Items.append(newitem)
            }
        } catch {
            print("Cannot get list of product")
        }
        for item in Items {
            print("each product = \(item)")
        }
        return Items
    }
    
    
    func queryItemById(itemId:Int64) -> Item?{
        do{
            let line = tblItems.filter(Itemid == itemId)
            if let item = try db?.pluck(line){
                let newitem = Item(id: (item[Itemid]) , code: (item[ItemCode]), type: (item[Itemtype]), title: (item[ItemTitle]), price: (item[ItemPrice]), icon: (item[ItemIcon]), UoM: item[ItemUoMid],userid: item[ItemUserId],itemCode: item[ItemExpensesCode])
                return newitem
            }
            
            return nil
        }catch{
            print(error)
            return nil
        }
    }
    
    
   
    func queryItem(itemCode:String) -> Item?{
        do{
        let line = tblItems.filter(ItemCode == itemCode)
            if let item = try db?.pluck(line){
         let newitem = Item(id: (item[Itemid]) , code: (item[ItemCode]), type: (item[Itemtype]), title: (item[ItemTitle]), price: (item[ItemPrice]), icon: (item[ItemIcon]), UoM: item[ItemUoMid]!,userid: item[ItemUserId],itemCode: item[ItemExpensesCode])
                return newitem
            }
            
            return nil
        }catch{
            print(error)
        return nil
        }
    }
    
    func queryItemBy(code:String) -> Item?{
        do{
            let line = tblItems.filter(ItemCode == code)
            if let item = try db?.pluck(line){
                let newitem = Item(id: (item[Itemid]) , code: (item[ItemCode]), type: (item[Itemtype]), title: (item[ItemTitle]), price: (item[ItemPrice]), icon: (item[ItemIcon]), UoM: item[ItemUoMid],userid: item[ItemUserId],itemCode: item[ItemExpensesCode])
                return newitem
            }
            
            return nil
        }catch{
            print(error)
            return nil
        }
    }
    

    func findItemByTitle(title:String,userid:Int64) -> Int64?{
        do{
            let itemtbl = tblItems.filter(ItemTitle == title && ItemUserId == userid)
            if let item = try db?.pluck(itemtbl){
                let id = item[Itemid]
                return id
            }
            return nil
        }catch{
            return nil
        }
        
    }

    
        func updateItem(id:Int64, item: Item) -> Bool {
            let itemtbl = tblItems.filter(Itemid == id)
            do {
                let update = itemtbl.update([
                    ItemCode <- item.code, Itemtype <- item.type!,ItemIcon <- item.icon, ItemUoMid <- item.UoM ,ItemPrice <- item.price , ItemTitle <- item.title , ItemUserId <- item.userid
                    ,ItemExpensesCode <- item.itemCode
                    ])
                if try db!.run(update) > 0 {
                    print("Update item successfully")
                    return true
                }
            } catch {
                print("Update failed: \(error)")
            }
            
            return false
        }
 
    
        func deleteItem(Id: Int64) -> Bool {
            do {
                let tblFilterItem = tblItems.filter(Itemid == Id)
                try db!.run(tblFilterItem.delete())
                print("delete sucessfully")
                return true
            } catch {
    
                print("Delete failed")
            }
            return false
        }
    
//    func updateContact(productId:Int64, newProduct: Product) -> Bool {
//        let tblFilterProduct = tblProduct.filter(id == productId)
//        do {
//            let update = tblFilterProduct.update([
//                name <- newProduct.name,
//                imageName <- newProduct.imageName
//                ])
//            if try db!.run(update) > 0 {
//                print("Update contact successfully")
//                return true
//            }
//        } catch {
//            print("Update failed: \(error)")
//        }
//        
//        return false
//    }
//    
//    func deleteProduct(inputId: Int64) -> Bool {
//        do {
//            let tblFilterProduct = tblProduct.filter(id == inputId)
//            try db!.run(tblFilterProduct.delete())
//            print("delete sucessfully")
//            return true
//        } catch {
//            
//            print("Delete failed")
//        }
//        return false
//    }
    
    
    /////////////////// End Items  / / / //////////
    
    
    ///////// PriceList //////////////
    
    private let tblPriceList = Table("PriceList")
    private let pricelistid = Expression<Int64>("id")
    private let pricelistValue = Expression<String>("Value")
    private let PriceListNum = Expression<String>("PriceListNum")
    private let pricelistUserid = Expression<Int64>("userid")
    private let pricelistItemCode = Expression<String>("ItemCode")
    
    func createTablePriceList() {
        do {
            try db!.run(tblPriceList.create(ifNotExists: false) { table in
                table.column(pricelistid, primaryKey: true)
                table.column(pricelistValue)
                table.column(pricelistUserid, references: tblUser,UserId)
                table.column(PriceListNum)
                table.column(pricelistItemCode)
            })
            print("create PriceList table successfully")
        } catch {
            print("Unable to create PriceList table")
        }
    }
    
    
    func addPrice(price:Price) -> Int64? {
        do {
            let insert = tblPriceList.insert(pricelistValue <- price.value!,pricelistUserid <- price.userid!,PriceListNum <- price.PriceListNum!,pricelistItemCode <- price.ItemCode!)
            let id = try db!.run(insert)
            print("Insert to tblPrice successfully")
            return id
        } catch {
            print("Cannot insert to tblPrice")
            print(error)
            return nil
        }
    }
    
    
    func addPrice(value:String,priceListNum:String,userid:Int64,itemcode:String) -> Int64? {
        do {
            let insert = tblPriceList.insert(pricelistValue <- value,pricelistUserid <- userid,PriceListNum <- priceListNum,pricelistItemCode <- itemcode)
            let id = try db!.run(insert)
            print("Insert to tblPrice successfully")
            return id
        } catch {
            print("Cannot insert to tblPrice")
            print(error)
            return nil
        }
    }
    
    
    
    func queryAllPrices(userid:Int64) -> [Price] {
        var prices:[Price] = []
        
        do {
            for price in try db!.prepare(self.tblPriceList.filter(pricelistUserid == userid)) {
                let newPrice = Price(id: price[pricelistid], value: price[pricelistValue],PriceListNum:price[PriceListNum],ItemCode:price[pricelistItemCode],userid:price[pricelistUserid])
                
                prices.append(newPrice)
            }
        } catch {
            print("Cannot get list of price")
        }
        for price in prices {
            print("each price = \(price)")
        }
        return prices
    }
    
    func findPrice(value:String,userid:Int64) -> Int64?{
        do{
            let price = tblPriceList.filter(pricelistValue == value && pricelistUserid == userid)
            if let priceid = try db?.pluck(price){
            let id = priceid[pricelistid]
                return id
            }
            return nil
        }catch{
            return nil
        }
        
    }
    
    func findCustomerPrice(pricelistnum:String,itemCode:String,userid:Int64) -> Price?{
        do{
            let price = tblPriceList.filter(PriceListNum == pricelistnum && pricelistItemCode == itemCode && pricelistUserid == userid)
            if let priceid = try db?.pluck(price){
                let newprice = Price(id: priceid[pricelistid], value: priceid[pricelistValue],PriceListNum:priceid[PriceListNum],ItemCode:priceid[pricelistItemCode],userid:priceid[pricelistUserid])
                
                
                return newprice
            }
            return nil
        }catch{
            return nil
        }
        
    }
    
    
    
    func updatePrice(id:Int64, price:Price) -> Bool {
        let Pricetbl = tblPriceList.filter(pricelistid == id)
        do {
            let update = Pricetbl.update([
                pricelistValue <- price.value!,pricelistUserid <- price.userid!,pricelistItemCode <- price.ItemCode!,PriceListNum <- price.PriceListNum!
                
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deletePrice(Id: Int64) -> Bool {
        do {
            let tblFilterPrice = tblPriceList.filter(pricelistid == Id)
            try db!.run(tblFilterPrice.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    //////////// End of Price List  / ////////
    
    
    ///////// CustomerList ///////////
    
    private let tblCustomerList = Table("CustomerList")
    private let customerId = Expression<Int64>("id")
    private let customerName = Expression<String>("customerName")
    private let customerCode = Expression<String>("customerCode")
    private let customerpriceListid = Expression<String?>("priceListNum")
    private let customerCurrency = Expression<String>("CurrencyId")
    private let customerUserId = Expression<Int64>("UserId")
    
    
    func createTableCustomerList() {
        do {
            try db!.run(tblCustomerList.create(ifNotExists: false) { table in
                table.column(customerId, primaryKey: true)
                table.column(customerName)
                table.column(customerCode)
                table.column(customerCurrency)
                table.column(customerpriceListid)
                table.column(customerUserId, references: tblUser,UserId)
            })
            print("create CustomerList table successfully")
        } catch {
            print("Unable to create CustomerList table")
            print(error)
        }
    }
    
    
    func findCustomer(name:String,userid:Int64)->Int64?{
        do{
        let customertbl = tblCustomerList.filter(customerName == name && customerUserId == userid)
            if let customer = try db?.pluck(customertbl){
                return customer[customerId]
            }
            return nil
        }catch{
        
            print(error)
            return nil
        }
    }
    
    
    
    func addCustomer(customer:Customer) -> Int64? {
        do {
            if let code = customer.customerCode{
            if let newcustomer = queryCustomerByCode(code: code){
                if let id = newcustomer.CId{
                    return id
                }
                }
            }
            let insert = tblCustomerList.insert(or:.ignore,customerName <- customer.customerName! ,customerCode <- customer.customerCode!, customerCurrency <- customer.customerCurrency!,customerUserId <- customer.userid!,customerpriceListid <- customer.PriceListNum)
            let id = try db!.run(insert)
            print("Insert to tblCustomer successfully")
            return id
        } catch {
            print("Cannot insert to tblCustomer")
            print(error)
            return nil
        }
    }
    
    
    
    
    
    
//    func addCustomer(custumername:String,code:String,userid:Int64) -> Int64? {
//        do {
//            let insert = tblCustomerList.insert(customerName <- custumername ,customerCode <- code, customerCurrency <- customerCurncyid,customerUserId <- userid)
//            let id = try db!.run(insert)
//            print("Insert to tblCustomer successfully")
//            return id
//        } catch {
//            print("Cannot insert to tblCustomer")
//            print(error)
//            return nil
//        }
//    }
    
    func queryAllCustomers(userid:Int64) -> [Customer] {
        var customers:[Customer] = []
        
        do {
            for customer in try db!.prepare(self.tblCustomerList.filter(customerUserId == userid)) {
                let newcustomer = Customer(Id: customer[customerId], customerName: customer[customerName], customerCurrency: customer[customerCurrency],userid:customer[customerUserId],customerCode:customer[customerCode],pricelistnum:customer[customerpriceListid])
                customers.append(newcustomer)
            }
        } catch {
            print("Cannot get list of customers")
        }
        for customer in customers {
            print("each customer = \(customer)")
        }
        return customers
    }
    
    func queryCustomerPrice(pricelistnum:String,itemCode:String,userid:Int64) -> Price?{
        do{
            let customerPricetbl = tblPriceList.filter(PriceListNum == pricelistnum && pricelistItemCode == itemCode && pricelistUserid == userid)
           
            if let price = try db?.pluck(customerPricetbl){
            
                let newPrice = Price(id: price[pricelistid], value: price[pricelistValue], PriceListNum: price[PriceListNum], ItemCode: price[pricelistItemCode], userid: price[pricelistUserid])
                
                return newPrice
            }
    
            return nil
        }catch{
            print(error)
            return nil
        }
    }
    
    
    func queryHeaderCustomer(headerid:Int64)-> Customer?{
        do{
            let headertbl  = tblHeader.filter(Headerid == headerid)
            let header = try db!.pluck(headertbl)
            if let id = header?[headerCustomerId]{
                
                let customertbl = tblCustomerList.filter(customerId == id )
                let customer = try db!.pluck(customertbl)
                return Customer(Id: (customer?[customerId])!, customerName: (customer?[customerName])!, customerCurrency: (customer?[customerCurrency])!,userid:(customer?[customerUserId])!,customerCode:(customer?[customerCode])!,pricelistnum:customer?[customerpriceListid])
            }else{
            
                return nil
            }
            
        }catch{
            print(error)
            return nil
        
        }
    }
    
    
    func queryCustomerById(customerid:Int64)->Customer?{
        do{
            let customertbl = tblCustomerList.filter(customerId == customerid)
            if let customer = try db?.pluck(customertbl){
                return Customer(Id: customer[customerId], customerName: customer[customerName], customerCurrency: customer[customerCurrency],userid:customer[customerUserId],customerCode:customer[customerCode],pricelistnum:customer[customerpriceListid])
            }
            return nil
        }catch{
            
            print(error)
            return nil
        }
    }
    
    
    func queryCustomerByPriceId(priceListId:String)->Customer?{
        do{
            let customertbl = tblCustomerList.filter(customerpriceListid == priceListId)
            if let customer = try db?.pluck(customertbl){
                return Customer(Id: customer[customerId], customerName: customer[customerName], customerCurrency: customer[customerCurrency],userid:customer[customerUserId],customerCode:customer[customerCode],pricelistnum:customer[customerpriceListid])
            }
            return nil
        }catch{
            
            print(error)
            return nil
        }
    }
    
    
    func queryCustomerByCode(code:String)->Customer?{
        do{
            let customertbl = tblCustomerList.filter(customerCode == code)
            if let customer = try db?.pluck(customertbl){
                return Customer(Id: customer[customerId], customerName: customer[customerName], customerCurrency: customer[customerCurrency],userid:customer[customerUserId],customerCode:customer[customerCode],pricelistnum:customer[customerpriceListid])
            }
            return nil
        }catch{
            
            print(error)
            return nil
        }
    }
    
    
    func updateCustomer(id:Int64, customer: Customer) -> Bool {
        let customertbl = tblCustomerList.filter(customerId == id)
        do {
            let update = customertbl.update([
                customerName <- customer.customerName! ,customerCode <- customer.customerCode!, customerCurrency <- customer.customerCurrency!,customerUserId <- customer.userid!
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deleteCustomer(Id: Int64) -> Bool {
        do {
            let tblFilterCustomer = tblCustomerList.filter(customerId == Id)
            try db!.run(tblFilterCustomer.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    
    
    
    /////// End of CustomerList //////////
    
    
    //////// Setup ///////////
    private let tblSetup = Table("Setup")
    private let setupId = Expression<Int64>("id")
    private let setupUserId = Expression<Int64>("UserId")
    private let SetupUserPassword = Expression<Int64?>("UserPassword")
    
    
    
    func createTableSetup() {
        do {
            try db!.run(tblSetup.create(ifNotExists: false) { table in
                table.column(setupId, primaryKey: true)
                table.column(setupUserId ,references:tblUser,UserId)
                table.column(SetupUserPassword)
            })
            print("create Setup table successfully")
        } catch {
            print("Unable to create Setup table")
        }
    }
    
    ///// End of setup ////////////
    
    
    
    
    ////// images //////
    
    private let tblImages = Table("Images")
    private let ImageId = Expression<Int64>("id")
    private let ImageHeaderId = Expression<Int64>("HeaderId")
    private let ImageTitle = Expression<String>("title")
    private let ImageUserId = Expression<Int64>("UserId")
    private let ImageData = Expression<SQLite.Blob>("image")
    
    
    
    
    func createTableImage() {
        do {
            try db!.run(tblImages.create(ifNotExists: false) { table in
                table.column(ImageId, primaryKey: true)
                table.column(ImageHeaderId ,references:tblHeader,Headerid)
                table.column(ImageTitle)
                table.column(ImageUserId, references: tblUser,UserId)
                table.column(ImageData)
            })
            print("create Image table successfully")
        } catch {
            print("Unable to create Image table")
        }
    }
    
    func addImage(headerid:Int64,image:String,data:Blob,userid:Int64)-> Int64? {
        do {
            
                let insert = tblImages.insert(ImageHeaderId <- headerid ,ImageTitle <- image,ImageData <- data,ImageUserId <- userid)
                let id = try db!.run(insert)
                print(id)
                print("Insert to Images successfully")
            return id
        } catch {
            print("Cannot insert to images")
            print(error)
            return nil
        }
    }
    
    
    func addImages(headerid:Int64,images:[Image],userid:Int64) {
        do {
            for image in images{
                let insert = tblImages.insert(ImageHeaderId <- headerid ,ImageTitle <- image.title,ImageData <- image.data ,ImageUserId <- userid)
                let id = try db!.run(insert)
                print(id)
            print("Insert to Images successfully")
            }
            
        } catch {
            print("Cannot insert to images")
            print(error)
        }
    }
    
    func queryHeaderImages(headerid:Int64) -> [Image]{
        var images:[Image] = []
        
        do {
            for image in try db!.prepare(self.tblImages.filter(ImageHeaderId == headerid)) {
                let newimage = Image(id: image[ImageId], title: image[ImageTitle], headerId: image[ImageHeaderId],userid: image[ImageUserId], data:image[ImageData])
                images.append(newimage)
            }
        } catch {
            print("Cannot get list of images")
        }
        return images
    }
    
    
    func deleteImage(Id: Int64) -> Bool {
        do {
            let tblFilterImage = tblImages.filter(ImageId == Id)
            try db!.run(tblFilterImage.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    func updateImage(id:Int64, image: Image) -> Bool {
        let tbl = tblImages.filter(ImageId == id)
        do {
            let update = tbl.update([
                ImageHeaderId <- image.headerId ,
                ImageTitle <- image.title,
                ImageData <- image.data,
                ImageUserId <- image.userid
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    ////// End of Images /////////
    
//    ////////////// LineItems //////////////
//    
//    private let tblLineItems = Table("LineItems")
//    private let LineItems_LineId = Expression<Int64>("LineId")
//    private let LineItems_ItemId = Expression<Int64>("ItemId")
//    
//    
//    
//    
//    
//    func createTableLineItems() {
//        do {
//            try db!.run(tblLineItems.create(ifNotExists: false) { table in
//                table.column(LineItems_ItemId,references:tblItems,Itemid)
//                table.column(LineItems_LineId ,references:tblLine,Lineid)
//            })
//            print("create LineItems table successfully")
//        } catch {
//            print("Unable to create LineItems table")
//        }
//    }
//    
//    
//    /////// End of Line Items ///////////////
//    
    
    
    ////////////// UoM //////////////
    
    private let tblUoM = Table("UnitOfMeasurement")
    private let UomId = Expression<Int64>("Id")
    private let Uom_Title = Expression<String>("Title")
    private let UomUserId = Expression<Int64>("UserId")
    
    
    
    
    func createTableUoM() {
        do {
            try db!.run(tblUoM.create(ifNotExists: false) { table in
                table.column(UomId,primaryKey:true)
                table.column(Uom_Title)
                table.column(UomUserId, references: tblUser,UserId)
            })
            print("create LineItems table successfully")
        } catch {
            print("Unable to create LineItems table")
        }
    }
    
    func addUoM(uom:UoM) -> Int64? {
        do {
            
            if let title = uom.title , let userid = uom.userid{
                if let id = findUoM(value: title, userid: userid){
                    return id
                }
            }
            
            let insert = tblUoM.insert(or:.ignore,Uom_Title <- uom.title!,UomUserId <- uom.userid!)
            let id = try db!.run(insert)
            print("Insert to tblItems successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    
    func addUoM(title:String,userid:Int64) -> Int64? {
        do {
            let insert = tblUoM.insert(Uom_Title <- title,UomUserId <- userid)
            let id = try db!.run(insert)
            print("Insert to tblItems successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllUoM(userid:Int64) -> [UoM] {
        var UoMs = [UoM]()
        
        do {
            for uom in try db!.prepare(self.tblUoM.filter(UomUserId == userid)) {
                let newUoM = UoM(id: uom[UomId], title: uom[Uom_Title],userid:uom[UomUserId])
                UoMs.append(newUoM)
            }
        } catch {
            print("Cannot get list of product")
        }
        for uom in UoMs {
            print("each product = \(uom)")
        }
        return UoMs
    }
    
    func findUoM(value:String,userid:Int64) -> Int64?{
        do{
            let uom = tblUoM.filter(Uom_Title == value && UomUserId == userid)
            if let uomid = try db?.pluck(uom){
            let id = uomid[UomId]
                return id
            
            }
            return nil
        }catch{
            return nil
        }
        
    }
    
    func queryUoMbyId(id:Int64) -> UoM?{
    
        do{
            let uomtbl = tblUoM.filter(UomId == id)
            if let uom = try db?.pluck(uomtbl){
                let newuom = UoM(id: uom[UomId], title: uom[Uom_Title],userid:uom[UomUserId])
                return newuom
            }
            
            return nil
        }catch{
            print(error)
            return nil
        }
    
    }
    
    
    func updateUoM(id:Int64, uom: UoM) -> Bool {
        let uomtbl = tblUoM.filter(UomId == id)
        do {
            let update = uomtbl.update([
                Uom_Title <- uom.title!,
                UomUserId <- uom.userid!
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deleteUoM(Id: Int64) -> Bool {
        do {
            let tblFilteruom = tblUoM.filter(UomId == Id)
            try db!.run(tblFilteruom.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    
    /////// End of UoM ///////////////
    
    ///////// Currency   ///////////
    
    private let tblCurrency = Table("Currency")
    private let CurrencyId = Expression<Int64>("Id")
    private let currencytitle = Expression<String>("Title")
    private let CurrencyUserId = Expression<Int64>("UserId")
    
    
    
    
    func createTableCurrency() {
        do {
            try db!.run(tblCurrency.create(ifNotExists: false) { table in
                table.column(CurrencyId,primaryKey:true)
                table.column(currencytitle)
                table.column(UomUserId, references: tblUser,UserId)
            })
            print("create Curency table successfully")
        } catch {
            print("Unable to create Currency table")
        }
    }
    
    
    
    func addCurrency(currency:Currency) -> Int64? {
        do {
            if let title = currency.title,let userid = currency.userid{
                if let id = findCurrency(title: title, userid: userid){
                    return id
                }
            }
            let insert = tblCurrency.insert(or:.ignore,currencytitle <- currency.title!,CurrencyUserId <- currency.userid!)
            let id = try db!.run(insert)
            print("Insert to tblCurrency successfully")
            return id
        } catch {
            print("Cannot insert to tblCurrency")
            print(error)
            return nil
        }
    }
    
    
    func addCurrency(title:String,userid:Int64) -> Int64? {
        do {
            let insert = tblCurrency.insert(currencytitle <- title,CurrencyUserId <- userid)
            let id = try db!.run(insert)
            print("Insert to tblCurrency successfully")
            return id
        } catch {
            print("Cannot insert to tblCurrency")
            print(error)
            return nil
        }
    }
    
    func queryAllCurrency(userid:Int64) -> [Currency] {
        var currencies = [Currency]()
        
        do {
            for currency in try db!.prepare(self.tblCurrency.filter(CurrencyUserId == userid)) {
                let newCurrency = Currency(id: currency[CurrencyId], title: currency[currencytitle],userid:currency[CurrencyUserId])
                currencies.append(newCurrency)
            }
        } catch {
            print("Cannot get list of currencies")
        }
        for currency in currencies {
            print("each currency = \(currency)")
        }
        return currencies
    }
    
    
    func findCurrency(title:String,userid:Int64) -> Int64?{
        do{
            let currency = tblCurrency.filter(currencytitle == title && CurrencyUserId == userid)
            if let currencyid = try db?.pluck(currency){
            let id = currencyid[CurrencyId]
                return id
            }
            return nil
        }catch{
            return nil
        }
    }
    
    
    
    func updateCurrency(id:Int64, currency: Currency) -> Bool {
        let currencytbl = tblCurrency.filter(CurrencyId == id)
        do {
            let update = currencytbl.update([
                currencytitle <- currency.title!,
                CurrencyUserId <- currency.userid!
                ])
            if try db!.run(update) > 0 {
                print("Update item successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    
    func deleteCurrency(Id: Int64) -> Bool {
        do {
            let tblFilterCurrency = tblCurrency.filter(CurrencyId == Id)
            try db!.run(tblFilterCurrency.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    ////// End of Currency //////////
    
    
    private let tblDocumentType = Table("DocumentType")
    private let documentTypeId = Expression<Int64>("Id")
    private let documentTypeTitle = Expression<String>("Title")
    private let documentTypeUserId = Expression<Int64>("UserId")
    
    
    func createTableDocumentType() {
        do {
            try db!.run(tblDocumentType.create(ifNotExists: false) { table in
                table.column(documentTypeId,primaryKey:true)
                table.column(documentTypeTitle)
                table.column(documentTypeUserId, references: tblUser,UserId)
            })
            print("create Curency table successfully")
        } catch {
            print("Unable to create Currency table")
        }
    }
    
    
    
    
    func addDocumnetType(title:String,userid:Int64) -> Int64? {
        do {
            let insert = tblDocumentType.insert(
                documentTypeTitle  <- title,
                documentTypeUserId <- userid
            )
            let id = try db!.run(insert)
            print("Insert to tblCurrency successfully")
            return id
        } catch {
            print("Cannot insert to tblCurrency")
            print(error)
            return nil
        }
    }
    
    
    
    func queryAllDocumnetType(userid:Int64) -> [DocumnetType] {
        var documentTypes = [DocumnetType]()
        
        do {
            for docType in try db!.prepare(self.tblDocumentType.filter(documentTypeUserId == userid)) {
                let newdocType = DocumnetType(id: docType[documentTypeId], title: docType[documentTypeTitle], userid: docType[documentTypeUserId])
                documentTypes.append(newdocType)
            }
        } catch {
            print("Cannot get list of document Type")
        }
        for doctype in documentTypes {
            print("each currency = \(doctype)")
        }
        return documentTypes
    }
    
    
    //
    
}
