
//
//  CurrencyViewController.swift
//  expenses
//
//  Created by Nour  on 8/8/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class CurrencyViewController: AbstractController ,UITableViewDelegate,UITableViewDataSource,currencyCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    
    var cellid = "titleCell"
    
    
    var currencies:[Currency] = []
    var filterCurrencies:[Currency] = []
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addbtn
        
        
        let nib = UINib(nibName: cellid, bundle:nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        self.showNavBackButton = true
        
        tableView.tableFooterView = UIView()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func search(_ sender: UITextField) {
        
        let item = sender.text?.trimed.lowercased()
        
        if !(item?.isEmpty)!{
        isSearching = true
            handelSearch(item: item!)
        }else{
        isSearching = false
            tableView.reloadData()
        }
        
    }
    
    
    func handelSearch(item:String){
    
        filterCurrencies = currencies.filter({
        
        $0.title.lowercased().contains(item)
        })
    
        tableView.reloadData()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        guard let user = Globals.user else{
            return
        }
        currencies = user.getCurrencies()
        tableView.reloadData()
        
    }
    func delete(currency: Currency) {
        let alert = UIAlertController(title: "", message: "you are about to delete a currency", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            currency.delete()
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func edit(currency: Currency) {
        let vc = UIStoryboard.viewController(identifier: "EditCurrencyViewController") as! EditCurrencyViewController
        vc.currency = currency
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func add(){
        let vc = UIStoryboard.viewController(identifier: "NewCurrencyViewController") as! NewCurrencyViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filterCurrencies.count
        }
        return currencies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! titleCell
        if isSearching{
            cell.currency = filterCurrencies[indexPath.row]
        }else{
            cell.currency = currencies[indexPath.row]
        }
        cell.currencydelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

