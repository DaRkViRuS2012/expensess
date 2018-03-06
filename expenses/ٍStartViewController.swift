//
//  ٍStartViewController.swift
//  expenses
//
//  Created by Nour  on 10/25/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class StartViewController: AbstractController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        prepareNavgationBar()
        if let _ = Globals.user{
            let vc = UIStoryboard.viewController(identifier: "HomeViewController") as! HomeViewController
            self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        }
        
    }

    func prepareNavgationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    
}
