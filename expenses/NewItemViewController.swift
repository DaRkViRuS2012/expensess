
//
//  NewItemViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//
import UIKit
import DropDown
class NewItemViewController: AbstractController {
    
    @IBOutlet weak var ItemTitle: UITextField!
    
    @IBOutlet weak var ItemCode: UITextField!
    
    @IBOutlet weak var itemType: UIButton!
    @IBOutlet weak var ItemPrice: UITextField!
    @IBOutlet weak var ItemUoM: UIButton!
    @IBOutlet weak var itemIcon: UIButton!
    
    let PricedropDown = DropDown()
    let TypedropDown = DropDown()
    let UoMdropDown = DropDown()
    let IcondropDown = DropDown()
    
    var prices:[Price] = []
    
    var pricelist:[String] = []

    let typeList:[String] = ["Customer","Employee"]
    var UoMs:[UoM] = []
    var UoMList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUoM()
       self.showNavBackButton = true
        prepareTypeDropDown()
        prepareUoMDropDown()
        self.showNavCloseButton = true
        
    }
    
    
    
    
    
    func prepareTypeDropDown(){
    
        TypedropDown.anchorView = itemType
        TypedropDown.dataSource = typeList
        
        TypedropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.itemType.setTitle(item, for: .normal)
        }
        

    }
    
    
    func prepareUoMDropDown(){
        
        UoMdropDown.anchorView = ItemUoM
        UoMdropDown.dataSource = UoMList
        
        UoMdropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.ItemUoM.setTitle(item, for: .normal)
        }
        
        
    }
    
    
    
   
    
    
    
    
    
    func loadUoM(){
        guard let user = Globals.user else{
            return
        }
        UoMs = user.getUoM()
        if(UoMs.count>0){
            ItemUoM.setTitle(UoMs[0].title, for: .normal)
        }
        UoMList = UoMs.map({ $0.title! })
    }
    
    
    
  

    
    
    
    @IBAction func toggleTypeDropDown(_ sender: UIButton) {
        if TypedropDown.isHidden{
            TypedropDown.show()
        
        }else{
            TypedropDown.hide()
        }
    }
    
    
    @IBAction func toggleUoMDropDown(_ sender: UIButton) {
        
        if UoMdropDown.isHidden {
            UoMdropDown.show()
        
        }else{
            UoMdropDown.hide()
        }
        
    }

    
    
    
    
    
    @IBAction func save(_ sender: UIButton) {
        
        
        
        let itemtitle = ItemTitle.text?.trimmed
        let code = ItemCode.text?.trimmed
        let type = itemType.titleLabel?.text
        let price = ItemPrice.text?.trimmed
        let uom  = ItemUoM.titleLabel?.text
        let icon = "food"
        
        guard let user = Globals.user else{
            return
        }
        
        
        
      //  let uomid = DatabaseManagement.shared.findUoM(value: uom!,userid:user.UserId)
        
        
        
        let userid = user.UserId
        
        if((itemtitle?.characters.count)! > 0 && (code?.characters.count)! > 0){
            if let _ = Double(price!){
                let item = Item(id: -1, code: code!, type: type!, title: itemtitle!, price: price!, icon: icon, UoM: uom!, userid: userid)
                item.save()
                self.dismiss(animated: true, completion: nil)
                return
                }
            }
        
        
        
            let alert = UIAlertController(title: "Wrong Data", message: "Enter a vaild data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
      
        endEdit()
        
        return true
    }
    
    
    
    
}
