//
//  UoMViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class UoMViewController: AbstractController,UITableViewDelegate,UITableViewDataSource ,uomCellDelegate{
    @IBOutlet weak var tableView: UITableView!

    var cellid = "titleCell"
    
    var UoMs:[UoM] = []
    var filterUOM:[UoM] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addbtn
        
        
        let nib =  UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        self.showNavBackButton = true
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
    UoMs = user.getUoM()
    tableView.reloadData()
    
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
        
        filterUOM = UoMs.filter({
            
            $0.title.lowercased().contains(item)
        })
        
        tableView.reloadData()
    }
    
    
    
    
    func edit(uom: UoM) {
        let vc = UIStoryboard.viewController(identifier: "EditUoMViewController") as! EditUoMViewController
        vc.uom = uom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func delete(uom: UoM) {
        let alert = UIAlertController(title: "", message: "you are about to delete a UoM", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            uom.delete()
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func add(){
        let vc = UIStoryboard.viewController(identifier: "NewUoMViewController") as! NewUoMViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterUOM.count
        }
        return UoMs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! titleCell
        if isSearching{
            cell.uom  = filterUOM[indexPath.row]
        }else{
            cell.uom  = UoMs[indexPath.row]
        }
        cell.uomdelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

