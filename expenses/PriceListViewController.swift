//
//  PriceListViewController.swift
//  expenses
//
//  Created by Nour  on 8/7/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material

class PriceListViewController: AbstractController,UITableViewDelegate,UITableViewDataSource,PriceCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var cellId = "PriceCell"
    var prices:[Price] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addbtn
        
        let nib = UINib(nibName: cellId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
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
        prices = user.getPrices()
        tableView.reloadData()
        
    }
    
    func add(){
        let vc = UIStoryboard.viewController(identifier: "NewPriceViewController") as! NewPriceViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PriceCell
        cell.price = prices[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    
    func edit(price: Price) {
        let vc = UIStoryboard.viewController(identifier: "NewPriceViewController") as! NewPriceViewController
        vc.price = price
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func delete(price: Price) {
        
        
        let alert = UIAlertController(title: "", message: "you are about to delete a price", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            price.delete()
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
