//
//  HomeViewController.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class HomeViewController: AbstractController {

    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var customerBtn: UIButton!
    @IBOutlet weak var employeeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.titleLabel.textColor = .white
        prepareNavgationBar()
        
        guard let user = Globals.user else{
            return
        }
        
        welcomeLbl.text = "Welcome \(user.UserFirstName)"
//        for header in (Globals.user?.getAllCustomerHeaders())! {
//            header.delete()
//        }
        
    }

    func openTabBarat(index:Int){
    
    
    let vc = UIStoryboard.viewController(identifier: "HomeTabBarController") as! UITabBarController
    
    vc.selectedIndex = index
    self.present(vc, animated: true, completion: nil)
    
    }
    
    
    @IBAction func goToEmployee(_ sender: UIButton) {
        
    openTabBarat(index: 0)
    }
   
    @IBAction func goToCustomer(_ sender: Any) {
    openTabBarat(index: 1)
    }
    
    @IBAction func goToSetup(_ sender: Any) {
        openTabBarat(index: 2)
    }
    
    
    @IBAction func goToProfile(_ sender: UIButton) {
      openTabBarat(index: 3)
    }
    
    
    func prepareNavgationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }

}
