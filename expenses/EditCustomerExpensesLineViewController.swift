//
//  EditCustomerExpensesLineViewController.swift
//  expenses
//
//  Created by Nour  on 11/11/17.
//  Copyright © 2017 Nour . All rights reserved.
//


import UIKit
import DropDown
import Material
class EditCustomerExpensesLineViewController: AbstractController, UIImagePickerControllerDelegate {
    
    
    
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var itemBtn: UIButton!
    @IBOutlet weak var QuantityTxt: UITextField!
    @IBOutlet weak var PriceTxt: UITextField!
    @IBOutlet weak var UoMBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var DiscriptionTxt: UITextField!
    
    
    var customer:Customer?
    var customerid:Int64?
    var headerid:Int64?
    
    var line:Line?
    var itemid:Int64?
    var selectedItem:Item?
    let itemDropDown = DropDown()
    let UoMDropDown = DropDown()
    let currencyDropDown = DropDown()
    
    var selectedUOM:String?
    var selectedCurrency:String?
    
    var currencies:[Currency] = []
    var currenciesList:[String] = []
    var items:[Item] = []
    var itemsList:[String] = []
    
    var UoMs:[UoM]  = []
    var UoMList:[String]  = []
    var images:[Image] = []
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectItem),
                                               name: NSNotification.Name(rawValue: "selectItem"),
                                               object: nil)
    }
    
    
    func loadInfo(){
    
        
        itemBtn.setTitle(line?.item?.title, for: .normal)
        PriceTxt.text = "\((line?.LinePrice)!)"
        QuantityTxt.text = "\((line?.Qty)!)"
        UoMBtn.setTitle(line?.LineUoM, for: .normal)
        DiscriptionTxt.text = line?.ItemDiscription
        currencyBtn.setTitle(line?.currency, for: .normal)
        self.itemid = line?.item?.id
        self.selectedUOM = line?.LineUoM
        self.selectedCurrency = line?.currency
        self.selectedItem = line?.item
        
     
    
    
    }
    
    override func customizeView() {
        
        let saveBtn =  UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveBtn
        
        
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "imageCell")
        cameraBtn.setImage(Icon.photoCamera, for: .normal)
        
        prepareUoMList()
        
        prepareCurrenciesList()
        prepareUoMDropDown()
        prepareCurrencyDropDown()
        
        loadInfo()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.showNavBackButton = true
        
    }
    
    
    func validate()->Bool{
        
        
        
        let price = PriceTxt.text?.trimmed
        let qty = QuantityTxt.text?.trimmed
        let uom  = UoMBtn.titleLabel?.text
        
        let discrption = DiscriptionTxt.text?.trimmed
        let currency = currencyBtn.titleLabel?.text
        
        if itemid == nil {
            showMessage(message: "choose an item", type: .error)
            return false
        }
        
        
        if Double(price!) == nil{
            showMessage(message: "enter a vaild price", type: .error)
            return false
        }
        
        
        if Double(qty!) == nil{
            showMessage(message: "enter a vaild quantity", type: .error)
            return false
        }
        
        
        if Double(qty!) == nil{
            showMessage(message: "enter a vaild quantity", type: .error)
            return false
        }
        
        if selectedUOM == nil {
            
            showMessage(message: "choose an UOM", type: .error)
            return false
        }
        
        
        if selectedCurrency == nil {
            
            showMessage(message: "choose a currency", type: .error)
            return false
        }
        
        return true
    }

    
    
    func save(){
        
        
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
        
        line?.ItemId = itemid!
        line?.currency = currency!
        line?.LinePrice = Double(price!)!
        line?.LineUoM = uom!
        line?.Qty = Double(qty!)!
        line?.ItemDiscription = discrption!
        
        line?.save()
        
        for image in images{
           // image.headerId = (header?.Id)!
            image.userid = user.UserId
            image.save()
            
        }
       
            Globals.headerLines = Globals.headerLines?.filter({$0.Id != line?.Id})
            Globals.headerLines?.append(line!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
            self.navigationController?.popViewController(animated: true)
        
        }
        
    }
    
    
    
    
    func loadCustomerPrice(){
        
        
            guard let user = Globals.user else{
                return
            }
            
            if let price = customer?.getPrice(itemId: (selectedItem?.id)!){
                PriceTxt.text = price.value
            }else{
                PriceTxt.text = selectedItem?.price
            }
        
        
    }

    
    
    func prepareCurrenciesList(){
        guard let user = Globals.user else{
            return
        }
        currencies = user.getCurrencies()
        currenciesList = currencies.map({$0.title})
        if let _ = customer{
            currencyBtn.setTitle(customer?.customerCurrency, for: .normal)
            self.selectedCurrency = customer?.customerCurrency
        }
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
        UoMList = UoMs.map({$0.title})
      
    }
    
 
    
    func prepareCurrencyDropDown(){
        currencyDropDown.anchorView = currencyBtn
        
        currencyDropDown.dataSource = currenciesList
        
        currencyDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedCurrency = item
            self.currencyBtn.setTitle(item, for: .normal)
            
        }
        
        
    }
    
    @IBAction func toggleItemDropDown(_ sender: UIButton) {
        
        let vc = UIStoryboard.viewController(identifier: "ItemsViewController") as! ItemsViewController
        vc.selectMode = true
        vc.type = true
        self.present(vc, animated: true, completion: nil)
    }
    
    func selectItem(){
        if let item = Globals.item{
            itemBtn.setTitle(item.title, for: .normal)
            self.selectedItem = item
            self.itemid = item.id
            self.UoMBtn.setTitle(item.UoM, for: .normal)
            self.selectedUOM = item.UoM
            self.loadCustomerPrice()
            
        }
        
    }
    
    func prepareUoMDropDown(){
        UoMDropDown.anchorView = UoMBtn
        
        UoMDropDown.dataSource = UoMList
        
        UoMDropDown.selectionAction = {  (index: Int, item: String) in
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
    
    
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        endEdit()
        let alertController  = UIAlertController(title: "Choose source", message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
        
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openGallery))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func openCamera(action: UIAlertAction){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func openGallery(action: UIAlertAction){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
    
        let date :NSDate = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        let imageName = "\(dateFormatter.string(from: date as Date)).jpg"
        
        
        let newimage = Image(id: -1, title: imageName, headerId: -1, userid: -1, data: image.datatypeValue)
        images.append(newimage)
        
        collectionView.reloadData()
        
        self.dismiss(animated: true, completion: nil);
    }
    
    
}




extension EditCustomerExpensesLineViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ImageCellDelegate{
    
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
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
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
        self.images = self.images.filter({$0.id != image.id})
        image.delete()
        collectionView.reloadData()
    }
    
    
}
