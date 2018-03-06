//
//  CustomersViewController.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class CustomersViewController: AbstractController,UITableViewDelegate,UITableViewDataSource,CustomerCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var selectMode = false
    
    
    let cellid = "CustomerCell"
    
    var customers:[Customer] = []
    var filterCustomer:[Customer] = []
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.clearButtonMode = .whileEditing
        
        
//        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
//        self.navigationItem.rightBarButtonItem = addbtn
        let nib = UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        self.showNavBackButton = true
        tableView.tableFooterView = UIView()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        guard let user = Globals.user else{
            return
        }
        customers = user.getCustomers()
        tableView.reloadData()
        
    }
    

    @IBAction func close(_ sender: UIButton) {
        if selectMode{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func search(_ sender: UITextField) {
        
        let item = sender.text?.trimed.lowercased()
        
        if !(item?.isEmpty)!{
            isSearching = true
            handelSearch(item: (item?.lowercased())!)
        }else{
            isSearching = false
            tableView.reloadData()
        }
        
    }
    
    
    func handelSearch(item:String){
        
        filterCustomer = customers.filter({
            
            $0.customerName.lowercased().contains(item) || $0.customerCode.contains(item)
        })
        
        tableView.reloadData()
    }

    func delete(customer: Customer) {
        
        let alert = UIAlertController(title: "", message: "you are about to delete a Customer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            customer.delete()
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func edit(customer: Customer) {
        let vc = UIStoryboard.viewController(identifier: "EditCustomerViewController") as! EditCustomerViewController
        vc.customer = customer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func add(){
        let vc = UIStoryboard.viewController(identifier: "NewCustomerViewController") as! NewCustomerViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterCustomer.count
        }
        return customers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! CustomerCell
        
        cell.delegate = self
        if isSearching {
            cell.customer = filterCustomer[indexPath.row]
        }else{
            cell.customer = customers[indexPath.row]
        }
        if selectMode{
            cell.selectMode()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectMode{
            if isSearching {
            
            Globals.customer = filterCustomer[indexPath.row]
            }else{
            Globals.customer = customers[indexPath.row]
            }
         
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectCustomer"), object: nil)
            
            self.dismiss(animated: true, completion: nil)
        
        }
    }
    
    
}
