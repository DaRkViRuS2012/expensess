//
//  NewEmployeeExpensesViewController.swift
//  expenses
//
//  Created by Nour  on 8/4/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import DropDown
//import Popover

class NewEmployeeExpensesViewController: AbstractController,CalendarViewDelegate{

    @IBOutlet weak var dateTextField: UITextField!

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
    @IBOutlet weak var isDraftSwitch: UISwitch!
    
    
    
    var header:Header?
    
    var editMode = false
    
    
    //date picker 
    var datePicker : UIDatePicker!
    
    var itemid:Int64?
    var itemCode:String?
    
    let itemDropDown = DropDown()
    let UoMDropDown = DropDown()
    let currencyDropDown = DropDown()
    
    var currencies:[Currency] = []
    var currenciesList:[String] = []
    
    var items:[Item] = []
    var itemsList:[String] = []
    
    var UoMs:[UoM]  = []
    var UoMList:[String]  = []
    var images:[Image] = []
    var imagesData:[UIImage] = []
    
    var customers:[Customer] = []
    var customerList:[String] = []
    var customerDropDown = DropDown()
    
    var selectedCustomer:Customer?
    var selectedUoM:String?
    var selectedCurrency:String?
    var isDraft = true
//
//    fileprivate lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        return formatter
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dateButton.setTitle(dateFormatter.string(from: Date()), for: .normal)
        
        var btns:[UIBarButtonItem] = []
        
        dateTextField.text = DateHelper.getStringFromDate(Date())
        let saveBtn =  UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save))
        btns.append(saveBtn)
        
        if editMode{
        let deleteBtn =  UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteHeader))
        
            btns.append(deleteBtn)
            self.setNavBarTitle(title: "Edit")
        }
        
        self.navigationItem.rightBarButtonItems = btns
        
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCell")
        
        
        cameraBtn.setImage(Icon.photoCamera, for: .normal)
        
        prepareUoMList()
        prepareCurrenciesList()
        prepareUoMDropDown()
        prepareCurrencyDropDown()
    
        if  editMode{
            if let _ = header {
                loadHeaderData()
            }
        }
        
        self.showNavBackButton = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    override func backButtonAction(_ sender: AnyObject) {
        if !editMode{
            for image in images{
                image.delete()
            }
        }
        self.popOrDismissViewControllerAnimated(animated:true)
    }
    
    
    
    @objc func deleteHeader(){
        let alert = UIAlertController(title: "", message: "Are you sure to delete the expense", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.header?.delete()
            self.popOrDismissViewControllerAnimated(animated: true)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    func loadHeaderData(){
        if let _ = DateHelper.getStringFromDate((header?.headerCreatedDate)!){
            dateTextField.text = DateHelper.getStringFromDate((header?.headerCreatedDate)!)
            }
        itemBtn.setTitle(header?.HeaderLines[0].item?.title, for: .normal)
        self.itemid = header?.HeaderLines[0].item?.Itemid
        self.itemCode = header?.HeaderLines[0].item?.code
        PriceTxt.text = "\(Double((header?.HeaderLines[0].LinePrice)!))"
        QuantityTxt.text = "\(Int((header?.HeaderLines[0].Qty)!))"
        UoMBtn.setTitle(header?.HeaderLines[0].LineUoM, for: .normal)
        selectedUoM = header?.HeaderLines[0].LineUoM
        DiscriptionTxt.text = header?.HeaderLines[0].ItemDiscription
        currencyBtn.setTitle(header?.HeaderLines[0].currency, for: .normal)
        selectedCurrency = header?.HeaderLines[0].currency
       
        if let _ = header?.images{
            self.images =  (header?.images)!
        }
    
        if let _ = header?.headerCustomerId {
            if let cust = header?.customer{
                customerButton.setTitle(cust.customerName, for: .normal)
                self.selectedCustomer = cust
            }
        }
        customerButton.isEnabled = false
        if header?.HeaderIsSynced == true{
            isDraftSwitch.isEnabled = false
            isDraftSwitch.isOn = false
            isDraft = false
        }else{
            isDraft = header?.isDraft ?? true
            isDraftSwitch.isOn = isDraft
        }
    }
    
    @IBAction func setDraft(_ sender: UISwitch) {
        isDraft = sender.isOn
    }
    
    func validate()->Bool {
        let date = dateTextField.text
        let price = PriceTxt.text?.trimmed
        let qty = QuantityTxt.text?.trimmed
        if DateHelper.getDateFromString(date!) == nil {
            showMessage(message: "wrong date format dd-mm-yyyy", type: .error)
            return false
        }
        
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
        
        if selectedUoM == nil{
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
        let date = dateTextField.text
        let price = PriceTxt.text?.trimmed
        let qty = QuantityTxt.text?.trimmed
        let uom  = UoMBtn.titleLabel?.text
        let discrption = DiscriptionTxt.text?.trimmed
        let currency = self.selectedCurrency
        if validate(){
        guard let user = Globals.user else{
            return
        }

        let userid = user.UserId
        let expensesDate = DateHelper.getDateFromString(date!)
        let state:ExpensesState =  .pendding //editMode ? ExpensesState(rawValue:(self.header?.headerStatus)!)! :
        let id = editMode ? header?.id : -1
            header = Header(id: id!, headerUserId: userid, headerCreatedDate: expensesDate!, headerPostedDate: DateHelper.getDateFromString(DateHelper.getStringFromDate(Date()) ?? "") ?? Date() , headerUpdateDate:  DateHelper.getDateFromISOString(DateHelper.getISOStringFromDate(Date()) ?? "") ?? Date(), headerExpensesType: "Employee", headerCustomerId: selectedCustomer?.CId, headerCustomerCode: selectedCustomer?.customerCode, headerisApproved: state, expaded: false, headerPhoneNumber: nil, headerBillingAddress: nil, headerShippingAddress: nil, headerContactPerson: nil, headerIsSynced: false, headerCostSource: "0", syncId: header?.syncId ?? "-1",deleted:false,isDraft: isDraft)
    
        header?.save()
        
        let lineid = editMode ? header?.HeaderLines[0].Id : -1
            let line = Line(Lineid: lineid!, headerId: (header?.id)!, Qty: Double(qty!)!, Amount: Double(qty!)! * Double(price!)!, currency: currency!, ItemDiscription: discrption!, LinePrice: Double(price!)!, ItemId: itemid!, itemCode: itemCode ?? "" , Lineuom: uom!, userid: userid)
        
        
        line.save()
        
        for image in images{
            
            image.headerId = (header?.id)!
            image.userid = user.UserId
            image.save()
            
        }
        
            self.popOrDismissViewControllerAnimated(animated: true)
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
            if item != "None"{
                self.currencyBtn.setTitle(item, for: .normal)
                self.selectedCurrency = self.currencies[index].title
            }else{
                self.selectedCurrency = nil
            }
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
            self.UoMBtn.setTitle(item.UoM, for: .normal)
            self.selectedUoM = item.UoM ?? ""
        }
    
    }
    
    func prepareUoMDropDown(){
        UoMDropDown.anchorView = UoMBtn
        
        UoMDropDown.dataSource = UoMList
        
        UoMDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            if item != "None"{
                self.UoMBtn.setTitle(item, for: .normal)
                self.selectedUoM = self.UoMs[index].title
            }else{
                self.selectedUoM = nil
            }
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
        self.selectedCustomer = nil
        self.customerButton.setTitle("None", for: .normal)
        let vc = UIStoryboard.viewController(identifier: "CustomersViewController") as! CustomersViewController
        vc.selectMode = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func selectCustomer(){
        
        if let customer = Globals.customer{
            customerButton.setTitle(customer.customerName, for: .normal)
            selectedCustomer = customer
            self.currencyBtn.setTitle(self.selectedCustomer?.customerCurrency, for: .normal)
            self.selectedCurrency = selectedCustomer?.customerCurrency
        }
        
    }
    
    
  
    

    @IBAction func takePhoto(_ sender: UIButton) {
        endEdit()
//        let alertController  = UIAlertController(title: "", message: "Choose image source", preferredStyle: .actionSheet)
//
//        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
//
//        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openGallery))
//         alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
        self.takePhoto()
    }
    
    
    
    override func setImage(image: UIImage) {
        let date :NSDate = NSDate()

        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"

        dateFormatter.timeZone = NSTimeZone(name: "GMT") as! TimeZone

        let imageName = "\(dateFormatter.string(from: date as Date)).jpg"


        if let updatedImage = image.updateImageOrientionUpSide() {

            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: updatedImage.datatypeValue)
            newimage.save()
            images.append(newimage)
            imagesData.append(image)
            collectionView.reloadData()
        } else {


            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: image.datatypeValue)
            newimage.save()
            images.append(newimage)
            imagesData.append(image)
            collectionView.reloadData()

        }
    }
//    func openCamera(action: UIAlertAction){
//
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//
//    }
//
//    func openGallery(action: UIAlertAction){
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
    

 
    
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
//        let date :NSDate = NSDate()
//
//        let dateFormatter = DateFormatter()
//        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
//        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
//
//        dateFormatter.timeZone = NSTimeZone(name: "GMT") as! TimeZone
//
//        let imageName = "\(dateFormatter.string(from: date as Date)).jpg"
//
//
//        if let updatedImage = image.updateImageOrientionUpSide() {
//
//            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: updatedImage.datatypeValue)
//            newimage.save()
//            images.append(newimage)
//            imagesData.append(image)
//            collectionView.reloadData()
//        } else {
//
//
//            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: image.datatypeValue)
//            newimage.save()
//            images.append(newimage)
//            imagesData.append(image)
//            collectionView.reloadData()
//
//        }
//
//
//
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    
    
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


extension NewEmployeeExpensesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ImageCellDelegate{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        cell.image = images[indexPath.item]
        cell.delegate = self
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
        
        
        let alert = UIAlertController(title: "", message: "Are you sure to delete the Image", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.images = self.images.filter({$0.id != image.id})
            image.delete()
            self.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        
        
        self.present(alert, animated: true, completion: nil)
        
       
    }
    
    
    // MARK: DatePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    
    @objc func doneClick() {
        
        dateTextField.text = DateHelper.getStringFromDate(datePicker.date)
        dateTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        dateTextField.resignFirstResponder()
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.dateTextField)
    }
    
    
}
