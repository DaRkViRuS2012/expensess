//
//  EditEmployeeExpensesViewController.swift
//  expenses
//
//  Created by Nour  on 11/12/17.
//  Copyright © 2017 Nour . All rights reserved.
//

    import UIKit
    import Material
    import DropDown
//    import Popover
    class EditEmployeeExpensesViewController: AbstractController,CalendarViewDelegate{
        
        
        @IBOutlet weak var dateButton: UIButton!
        @IBOutlet weak var cameraBtn: UIButton!
        @IBOutlet weak var currencyBtn: UIButton!
        @IBOutlet weak var itemBtn: UIButton!
        @IBOutlet weak var QuantityTxt: UITextField!
        @IBOutlet weak var PriceTxt: UITextField!
        @IBOutlet weak var UoMBtn: UIButton!
        @IBOutlet weak var collectionView: UICollectionView!
        @IBOutlet weak var DiscriptionTxt: UITextField!
        @IBOutlet weak var customerButton: UIButton!
        
        
        
        var itemid:Int64?
        var itemCode:String?
        
        let itemDropDown = DropDown()
        let UoMDropDown = DropDown()
        let currencyDropDown = DropDown()
        
        var currencies:[Currency] = []
        var currenciesList:[String] = []
        
        var items:[Item] = []
        var itemsList:[String] = []
        var header:Header?
        var UoMs:[UoM]  = []
        var UoMList:[String]  = []
        var images:[Image] = []
        
        
        var customers:[Customer] = []
        var customerList:[String] = []
        var customerDropDown = DropDown()
        var selectedCustomer:Customer?
        var selectedUOM:String?
        var selectedCurrency:String?
        
        fileprivate lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter
        }()
        
        
        override func viewWillAppear(_ animated: Bool) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(selectCustomer),
                                                   name: NSNotification.Name(rawValue: "selectCustomer"),
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(selectItem),
                                                   name: NSNotification.Name(rawValue: "selectItem"),
                                                   object: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            dateButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
            
            let saveBtn =  UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save))
            let deleteBtn =  UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteHeader))
            self.navigationItem.rightBarButtonItems = [saveBtn, deleteBtn]
            
            let nib = UINib(nibName: "ImageCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "imageCell")
            
            
            cameraBtn.setImage(Icon.photoCamera, for: .normal)
            prepareUoMList()
            prepareCurrenciesList()
            prepareUoMDropDown()
            prepareCurrencyDropDown()
            
       
            
            loadHeaderData()
            self.showNavBackButton = true
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
        
        
        func loadHeaderData(){
            dateButton.setTitle(DateHelper.getStringFromDate((header?.headerCreatedDate)!), for: .normal)
            itemBtn.setTitle(header?.HeaderLines[0].item?.title, for: .normal)
            self.itemid = header?.HeaderLines[0].item?.Itemid
            self.itemCode = header?.HeaderLines[0].item?.code
            PriceTxt.text = "\(Double((header?.HeaderLines[0].LinePrice)!))"
            QuantityTxt.text = "\(Int((header?.HeaderLines[0].Qty)!))"
            UoMBtn.setTitle(header?.HeaderLines[0].LineUoM, for: .normal)
            selectedUOM = header?.HeaderLines[0].LineUoM
            DiscriptionTxt.text = header?.HeaderLines[0].ItemDiscription
            currencyBtn.setTitle(header?.HeaderLines[0].currency, for: .normal)
            selectedCurrency = header?.HeaderLines[0].currency
           
            if let _ = header?.images{
                self.images =  (header?.images)!
            }
            
            if let _ = header?.headerCustomerId {
                if let cust = header?.customer{
                    customerButton.setTitle(cust.customerName, for: .normal)
                }
            }
            
        
        }
        
        
        
        func validate()->Bool{
            
            let item = itemBtn.titleLabel?.text
            let price = PriceTxt.text?.trimmed
            let qty = QuantityTxt.text?.trimmed
            let uom  = UoMBtn.titleLabel?.text
            let discrption = DiscriptionTxt.text?.trimmed
            let currency = currencyBtn.titleLabel?.text
            
            
            
            if itemid == nil || itemCode == nil{
                showMessage(message: "select an item", type: .error)
                return false
            }
            
            if Double(price!) == nil{
                showMessage(message: "enter a vaild price", type: .error)
                return false
            }
            
            if (qty?.isEmpty)! || Double(qty!) == nil{
                showMessage(message: "enter a vaild quantity", type: .error)
                return false
            }
            
            if selectedUOM == nil{
                showMessage(message: "choose a vaild UOM", type: .error)
                return false
            }
            
            if selectedCurrency == nil{
                showMessage(message: "choose a vaild currency", type: .error)
                return false
            }
            
            return true
        }
        
        @objc func save(){
            let date = dateButton.currentTitle
            let item = itemBtn.titleLabel?.text
            let price = PriceTxt.text?.trimmed
            let qty = QuantityTxt.text?.trimmed
            let uom  = UoMBtn.titleLabel?.text
            let discrption = DiscriptionTxt.text?.trimmed
            let currency = currencyBtn.titleLabel?.text
            
            if validate(){
            guard let user = Globals.user else{
                return
            }
            let userid = user.UserId
            let expensesDate = DateHelper.getDateFromString(date!)
                let header = Header(id: (self.header?.id)!, headerUserId: userid, headerCreatedDate: expensesDate!, headerPostedDate: Date(),headerUpdateDate:nil, headerExpensesType: "Employee", headerCustomerId: nil, headerCustomerCode: nil, headerisApproved: .pendding, expaded: false, headerPhoneNumber: nil, headerBillingAddress: nil, headerShippingAddress: nil, headerContactPerson: nil, headerIsSynced: false, headerCostSource: "", syncId: "", deleted: false,isDraft:true)
            header.save()
                let line = Line(Lineid: header.HeaderLines[0].Id!, headerId: header.id!, Qty: Double(qty!)!, Amount: Double(qty!)! * Double(price!)!, currency: currency!, ItemDiscription: discrption!, LinePrice: Double(price!)!, ItemId: itemid!, itemCode: itemCode ?? "", Lineuom: uom!, userid: userid)
            line.save()
            for image in images{
                image.headerId = header.id!
                image.userid = user.UserId
                image.save()
            }
            self.popOrDismissViewControllerAnimated(animated: true)
            }
        }
        
        
        
        @objc func deleteHeader(){
            let alert = UIAlertController(title: "Delete Expeness?", message: "are you sure?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
                self.header?.delete()
                self.popOrDismissViewControllerAnimated(animated: true)
            }
            let cancelAcion = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAcion)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        func prepareItemsList(){
            guard let user = Globals.user else{
                return
            }
            
            items = user.getEmployeeItems()
            itemsList = items.map({$0.title!})
            if itemsList.count > 0{
                itemBtn.setTitle(itemsList[0], for: .normal)
                self.itemid = self.items[0].Itemid
                self.itemCode = self.items[0].code
                self.UoMBtn.setTitle(self.items[0].UoM, for: .normal)
                self.PriceTxt.text = "\(self.items[0].price ?? "")"
            }
        }
        
        
        func prepareCurrenciesList(){
            guard let user = Globals.user else{
                return
            }
            currencies = user.getCurrencies()
            currenciesList = currencies.map({$0.title!})
        }
        
        @IBAction func toggleCurrencyDropDown(_ sender: UIButton) {
            
            if currencyDropDown.isHidden{
                currencyDropDown.show()
            }else{
                currencyDropDown.hide()
            }
        }
        
        func prepareUoMList(){
            guard let user = Globals.user else{
                return
            }
            UoMs = user.getUoM()
            UoMList = UoMs.map({$0.title!})
        }
        

        func prepareCurrencyDropDown(){
            currencyDropDown.anchorView = currencyBtn
            
            currencyDropDown.dataSource = currenciesList
            
            currencyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.selectedCurrency = item
                self.currencyBtn.setTitle(item, for: .normal)
            }
        }
        
        
        @IBAction func toggleItemDropDown(_ sender: UIButton) {
            
            let vc = UIStoryboard.viewController(identifier: "ItemsViewController") as! ItemsViewController
            vc.selectMode = true
            vc.type = false
            self.present(vc, animated: true, completion: nil)
        }
        
        @objc func selectItem(){
            if let item = Globals.item{
                itemBtn.setTitle(item.title, for: .normal)
                self.itemid = item.Itemid
                self.itemCode = item.code
                self.PriceTxt.text = "\(item.price ?? "")"
                
            }
            
        }
        
        func prepareUoMDropDown(){
            UoMDropDown.anchorView = UoMBtn
            
            UoMDropDown.dataSource = UoMList
            
            UoMDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.selectedUOM = item
                self.UoMBtn.setTitle(item, for: .normal)
            }
        }
        
        
        @IBAction func toggleUoMDropDown(_ sender: UIButton) {
            if UoMDropDown.isHidden{
                
                UoMDropDown.show()
            }else{
                UoMDropDown.hide()
            }
        }
    
        
        func prepareCustomerList(){
            guard let user = Globals.user else{
                return
            }
            customers = user.getCustomers()
            customerList = customers.map({$0.customerName!})
            customerList.insert("None", at: 0)
        }
        
        
        func prepareCustomerDropDown(){
            customerDropDown.anchorView = customerButton
            
            customerDropDown.dataSource = customerList
            
            customerDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.customerButton.setTitle(item, for: .normal)
                if item != "None"{
                    
                    self.selectedCustomer = self.customers[index - 1 ]
                    self.currencyBtn.setTitle(self.selectedCustomer?.customerCurrency, for: .normal)
                }else{
                    self.selectedCustomer = nil
                }
            }
        }
        
        @IBAction func toggleCustomerDropDown(_ sender: UIButton) {
            
            let vc = UIStoryboard.viewController(identifier: "CustomersViewController") as! CustomersViewController
            vc.selectMode = true
            self.present(vc, animated: true, completion: nil)
        }
        
        
        
        @objc func selectCustomer(){
            
            if let customer = Globals.customer{
                customerButton.setTitle(customer.customerName, for: .normal)
                currencyBtn.setTitle(customer.customerCurrency, for: .normal)
                selectedCustomer = customer
            }
            
        }
        
        
        @IBAction func takePhoto(_ sender: UIButton) {
            endEdit()
//            let alertController  = UIAlertController(title: "", message: "Choose image source", preferredStyle: .actionSheet)
//
//            alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
//
//            alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openGallery))
//            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
        }
        
        
//        func openCamera(action: UIAlertAction){
//            
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//                imagePicker.allowsEditing = false
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//            
//        }
//        
//        func openGallery(action: UIAlertAction){
//            
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//                imagePicker.allowsEditing = true
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//            
//        }
//        
//        
//        
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
//            let date :NSDate = NSDate()
//            
//            let dateFormatter = DateFormatter()
//            //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
//            dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
//            
//            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
//            
//            let imageName = "\(dateFormatter.string(from: date as Date)).jpg"
//            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: image.datatypeValue)
//            images.append(newimage)
//            collectionView.reloadData()
//            
//            self.dismiss(animated: true, completion: nil);
//        }
//        
        
        
        @IBAction func openCalendar(_ sender: UIButton) {
            let width = self.view.frame.width - 64
            let height = self.view.frame.height / 2
            let cv = CalendarView(frame: CGRect(x: 0, y: 0, width: width , height: height))
            cv.delegate = self
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: width , height: height))
            aView.addSubview(cv)
            
            let popover = Popover()
            popover.show(aView, fromView: self.dateButton)
        }
        
        
        
        func changeDate(date: Date) {
            let dateString = DateHelper.getStringFromDate(date)
            dateButton.setTitle(dateString, for: .normal)
        }
        
        
        
    }
    
    
extension EditEmployeeExpensesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ImageCellDelegate{
    

    
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            cell.image = images[indexPath.item]
            cell.delegate  = self
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 100)
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.images[indexPath.row]
        let newImageView = UIImageView(image: image.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .allowAnimatedContent, animations: {
            self.view.addSubview(newImageView)
        }, completion: nil)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    

        func delete(image: Image) {
            self.images = self.images.filter({$0.id != image.id})
            image.delete()
            collectionView.reloadData()
        }
        
}


