
//
//  NewCustomerExpensesViewController.swift
//  expenses
//
//  Created by Nour  on 8/10/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import DropDown
import Material
//import Popover
class NewCustomerExpensesViewController: AbstractController ,CalendarViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactPersonTextField: UITextField!
    @IBOutlet weak var shippingAddressTextField: UITextField!
    @IBOutlet weak var billingAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var customersBtn: UIButton!
    
    @IBOutlet weak var documentTypeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datePicker:UIDatePicker!
    
    let customersDropDown = DropDown()
    var customers:[Customer] = []
    var customersList:[String] = []
    
    var customerid:Int64?
    var selectedCustomer:Customer?
    
    var lines:[Line] = []
    
    
    var images:[Image] = []
    
    var cellid = "LineCell"
    
    var docuomentType:String?
    let documnetTypeDropDown = DropDown()
    var documentTypes:[DocumnetType] = []
    var documentTypesList:[String] = []
    
    
    var header:Header?
    var line:Line?
    var editMode = false
    
//    fileprivate lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        return formatter
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: NSNotification.Name(rawValue: "loadData"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectCustomer),
                                               name: NSNotification.Name(rawValue: "selectCustomer"),
                                               object: nil)
        
    }
    
    @objc func loadData(notification: Notification){
        lines = Globals.headerLines!
        tableView.reloadData()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func customizeView() {
        self.showNavBackButton = true
        
        
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCell")
        cameraBtn.setImage(Icon.photoCamera, for: .normal)
        
        
        prepareDocumnetTypesList()
        prepareDocumentTypeDropDown()
        
        var btns:[UIBarButtonItem] = []
        let saveBtn =  UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save))

        btns.append(saveBtn)

        dateTextField.text = DateHelper.getStringFromDate(Date())
        
        if !editMode{
            createNew()
            }else{
            let deleteBtn =  UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteHeader))
            btns.append(deleteBtn)
            loadHeaderData()
            lines = (header?.HeaderLines)!
            Globals.headerLines = header?.HeaderLines
        }
        self.navigationItem.rightBarButtonItems = btns
    
   
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let tbnib = UINib(nibName: cellid, bundle: nil)
        tableView.register(tbnib, forCellReuseIdentifier: cellid)
        
        
    }
    
    
    
    

    @objc func deleteHeader(){
    
    
    let alert = UIAlertController(title: "", message: "Are you sure to delete this expense", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
        
        self.header?.delete()
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
    
    alert.addAction(cancelAction)
    alert.addAction(alertAction)
    
    
    self.present(alert, animated: true, completion: nil)
    
}

func loadHeaderData(){
    dateTextField.text = DateHelper.getStringFromDate((header?.headerCreatedDate)!)
    billingAddressTextField.text = header?.headerBillingAddress
    phoneNumberTextField.text = header?.headerPhoneNumber
    shippingAddressTextField.text = header?.headerShippingAddress
    contactPersonTextField.text = header?.headerContactPerson
    customersBtn.setTitle(header?.customer?.customerName, for: .normal)
    selectedCustomer = header?.customer
    if let dc = header?.headerDocumenetType{
        self.docuomentType = header?.headerDocumenetType
        self.documentTypeButton.setTitle(dc, for: .normal)
    }
    if let imgs = header?.images{
        self.images = imgs
    }
    self.customersBtn.isEnabled = false
}


    func createNew(){
        guard let userid = Globals.user?.UserId else {
            return
        }
        let state:ExpensesState = .pendding // editMode ? ExpensesState(rawValue:(self.header?.headerStatus)!)! :
        
        header = Header(id: -1, headerUserId: userid, headerCreatedDate: Date(), headerPostedDate: Date(), headerUpdateDate: Date(), headerExpensesType: "Customer", headerCustomerId: self.selectedCustomer?.CId,headerCustomerCode: self.selectedCustomer?.customerCode, headerisApproved: state, expaded: false, headerPhoneNumber: nil, headerBillingAddress: nil, headerShippingAddress: nil, headerContactPerson: nil, headerIsSynced: false, headerCostSource: "", syncId: "-1", deleted: false)
        header?.save()
        Globals.headerLines = [Line]()
        lines = Globals.headerLines!
    }
    
    override func backButtonAction(_ sender: AnyObject) {
      
        if !editMode{
            self.header?.delete()
        }
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    
    func validate()->Bool{
    
        let date = dateTextField.text
        let billingAddress = billingAddressTextField.text
        let phoneNumber = phoneNumberTextField.text
        let shippingAddress = shippingAddressTextField.text
        let contactPerson = contactPersonTextField.text
        
        
        if DateHelper.getDateFromString(date!) == nil{
            showMessage(message: "invalid date format \n DD-MM-YYYY", type: .error)
            return false
        }
        
        if selectedCustomer == nil{
            showMessage(message: "select a customer", type: .error)
            return false
        }
        
        if !(phoneNumber?.isNumber)! || (phoneNumber?.isEmpty)!{
            showMessage(message: "enter a vaild phone number", type: .error)
            return false
        }
        
        
        
        if (shippingAddress?.isEmpty)!{
            showMessage(message: "enter shipping address", type: .error)
            return false
        }
        
        
        if (contactPerson?.isEmpty)!{
            showMessage(message: "enter contact Person", type: .error)
            return false
        }
        
        if docuomentType == nil{
            showMessage(message: "please choose a document Type", type: .error)
            return false
        }
        
    return true
    }
    
    
    @objc func save(){
        
        let date = dateTextField.text
        let billingAddress = billingAddressTextField.text
        let phoneNumber = phoneNumberTextField.text
        let shippingAddress = shippingAddressTextField.text
        let contactPerson = contactPersonTextField.text
        if validate(){
            guard let user = Globals.user else{
                return
            }
            let userid = user.UserId
            header?.headerCustomerId = self.selectedCustomer?.CId
            header?.headerCreatedDate = DateHelper.getDateFromString(date!)!
            header?.headerBillingAddress = billingAddress
            header?.headerShippingAddress = shippingAddress
            header?.headerContactPerson = contactPerson
            header?.headerPhoneNumber = phoneNumber
            header?.headerUserId = userid
            header?.headerDocumenetType = self.docuomentType
            header?.headerCustomerCode = selectedCustomer?.customerCode
            header?.HeaderIsSynced = false
            header?.headerStatus = 1
            header?.save()
            
            for image in images{
                image.headerId = (header?.id)!
                image.userid = userid
                image.save()
            }

            self.popOrDismissViewControllerAnimated(animated: true)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LineSegue"{
        
        let vc = segue.destination as! CustomerExpensesLineViewController
            vc.customerid = customerid
            vc.customer = selectedCustomer
            vc.headerid = header?.id
        }
        
        if segue.identifier == "editCustomerSegue"{
            
            let vc = segue.destination as! EditCustomerExpensesLineViewController
            vc.headerid  = self.header?.id
            vc.customerid = self.header?.customer?.CId
            vc.customer = selectedCustomer
            vc.line = self.line
        }
    }
    
    func prepareCustomerList(){
        guard let user = Globals.user else {
            return
        }
        customers = user.getCustomers()
        customersList = customers.map({ $0.customerName! })
        if customersList.count > 0 {
            customersBtn.setTitle(customersList[0], for: .normal)
            self.selectedCustomer = customers[0]
            //self.loadCustomerPrice()
        }
        
    }
    
    
    func prepareCustomerDropDown(){
        
        customersDropDown.anchorView = customersBtn
        customersDropDown.dataSource = customersList
        
        customersDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.customersBtn.setTitle(item, for: .normal)
            self.customerid = self.customers[index].CId
            self.selectedCustomer = self.customers[index]

        }
    }
    


    @IBAction func toggleCustomerDropDown(_ sender: UIButton) {
        
        let vc = UIStoryboard.viewController(identifier: "CustomersViewController") as! CustomersViewController
        vc.selectMode = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func selectCustomer(){
        
        if let customer = Globals.customer{
            customersBtn.setTitle(customer.customerName, for: .normal)
            selectedCustomer = customer
        }
        
    }
    
    
    
    func prepareDocumnetTypesList(){
    
        documentTypes = DatabaseManagement.shared.queryAllDocumnetType(userid: 1)
        documentTypesList = documentTypes.map({ $0.title })
    }
    
    
    func prepareDocumentTypeDropDown(){
        
        documnetTypeDropDown.anchorView = documentTypeButton
        documnetTypeDropDown.dataSource = documentTypesList
        
        documnetTypeDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.documentTypeButton.setTitle(item, for: .normal)
            self.docuomentType = self.documentTypesList[index]
        }
    }

    
    
    @IBAction func toggleDocumentTypeDropDown(_ sender: UIButton) {
        
        if documnetTypeDropDown.isHidden {
            documnetTypeDropDown.show()
        }else{
            documnetTypeDropDown.hide()
        }
        
    }
  
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
    
    
     func instanceFromNib() -> CalendarView {
        return UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CalendarView
    }
    
    
    
    func changeDate(date: Date) {
        let dateString = DateHelper.getStringFromDate(date)
        dateButton.setTitle(dateString, for: .normal)
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
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        endEdit()
//        let alertController  = UIAlertController(title: "Choose source", message: "", preferredStyle: .actionSheet)
//
//        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
//
//        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openGallery))
//        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
        self.takePhoto()
    }
    
    override func setImage(image: UIImage) {
        let date :NSDate = NSDate()

        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"

        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!

        let imageName = "\(dateFormatter.string(from: date as Date)).jpg"

        if let updatedImage = image.updateImageOrientionUpSide() {

            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: updatedImage.datatypeValue)
            newimage.save()
            images.append(newimage)
            collectionView.reloadData()
        } else {

            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: image.datatypeValue)
            newimage.save()
            images.append(newimage)
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
//
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//
//    }
//
//
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
//        let date :NSDate = NSDate()
//
//        let dateFormatter = DateFormatter()
//        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
//        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
//
//        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
//
//        let imageName = "\(dateFormatter.string(from: date as Date)).jpg"
//
//        if let updatedImage = image.updateImageOrientionUpSide() {
//
//            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: updatedImage.datatypeValue)
//            newimage.save()
//            images.append(newimage)
//            collectionView.reloadData()
//        } else {
//
//            let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: image.datatypeValue)
//            newimage.save()
//            images.append(newimage)
//            collectionView.reloadData()
//
//        }
//
//        self.dismiss(animated: true, completion: nil);
//    }
//
    
    
    
    
}




extension NewCustomerExpensesViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ImageCellDelegate{
    
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
    
}

extension NewCustomerExpensesViewController:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! LineCell
        cell.line = lines[indexPath.row]
        cell.delegate = self
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


extension NewCustomerExpensesViewController:LineCellDelegate{

    func delete(line: Line) {
        
        
        let alert = UIAlertController(title: "", message: "Are you sure to delete this Item", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.lines = self.lines.filter({$0.Id != line.Id})
            Globals.headerLines =  Globals.headerLines?.filter({$0.Id != line.Id})
            line.delete()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
      
    }
    
    func edit(line: Line) {
        self.line = line
        let vc = UIStoryboard.viewController(identifier: "CustomerExpensesLineViewController") as! CustomerExpensesLineViewController
        vc.line = line
        vc.header = self.header
        vc.headerid  = self.header?.id
        vc.customerid = self.header?.customer?.CId
        vc.customer = selectedCustomer
        vc.editMode = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

