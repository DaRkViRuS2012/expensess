//
//  ItemsViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class ItemsViewController: AbstractController,UITableViewDataSource,UITableViewDelegate ,ItemCellDelegate{
    @IBOutlet weak var typesegmentController: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var selectMode = false
    
    var cellid = "ItemCell"
    var Items:[Item] = []
    var EmployeeItems:[Item] = []
    var CustomerItems:[Item] = []
    var filterEmployeeItems:[Item] = []
    var filterCustomerItems:[Item] = []
    var isSearching:Bool = false
    var type:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.borderStyle = .none
//        
//        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
//        self.navigationItem.rightBarButtonItem = addbtn
        let nib = UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        
        loadData()
       // getItemsFromServer()
        self.showNavBackButton = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func search(_ sender: UITextField) {
        
     let item = sender.text?.trimed
        if !(item?.isEmpty)!{
            isSearching = true
            handleSearch(item: item!)
        }else{
            isSearching = false
            tableView.reloadData()
        }
        
    }
    
    
    func handleSearch(item:String){
    
        if type{
        
            filterCustomerItems = CustomerItems.filter({
            
                ($0.title?.lowercased().contains(item.lowercased()))! || ($0.code?.lowercased().contains(item.lowercased()))!
            })
            
        }else{
            filterEmployeeItems = EmployeeItems.filter({
                ($0.title?.lowercased().contains(item.lowercased()))! || ($0.code?.lowercased().contains(item.lowercased()))!
            })
        }
    
        tableView.reloadData()
        
    
    }
    
    @IBAction func close(_ sender: UIButton) {
        if selectMode {
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
    
    guard let user = Globals.user else{
        return
    }
    EmployeeItems = user.getEmployeeItems()
    CustomerItems = user.getCustomerItems()
    tableView.reloadData()
    
    }
    
    
    func add(){
    let vc = UIStoryboard.viewController(identifier: "NewItemViewController") as! NewItemViewController
    self.navigationController?.pushViewController(vc, animated: true)
    
    
    }
    
    @IBAction func changeType(_ sender: UISegmentedControl) {
        if typesegmentController.selectedSegmentIndex == 0 {
                type = false
        }else{
            type = true
        }
        tableView.reloadData()
    }
    
    
    func delete(item: Item) {
        
        let alert = UIAlertController(title: "", message: "you are about to delete an Item", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            item.delete()
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func edit(item: Item) {
        let vc = UIStoryboard.viewController(identifier: "EditItemViewController") as! EditItemViewController
        vc.item = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // get data from internet
   
}


extension ItemsViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type{
            if isSearching{
                return filterCustomerItems.count
            }else{
                return CustomerItems.count
            }
            
        }else{
            if isSearching{
                return filterEmployeeItems.count
            }else{
                return EmployeeItems.count
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ItemCell
        cell.delegate = self
        if !type{
            if isSearching{
                cell.item = filterEmployeeItems[indexPath.row]
            }else{
                cell.item = EmployeeItems[indexPath.row]
            }
        }else{
            if isSearching {
                cell.item = filterCustomerItems[indexPath.row]
                
            }else{
                cell.item = CustomerItems[indexPath.row]
            }
        }
        if selectMode{
            
            cell.selectMode()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectMode{
            if isSearching {
                if type{
                    Globals.item = filterCustomerItems[indexPath.row]
                }else{
                    Globals.item = filterEmployeeItems[indexPath.row]
                }
            }else{
                if type{
                    Globals.item = CustomerItems[indexPath.row]
                }else{
                    Globals.item = EmployeeItems[indexPath.row]
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectItem"), object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}
