//
//  SetupViewController.swift
//  expenses
//
//  Created by Nour  on 8/6/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class SetupViewController: AbstractController {

    @IBOutlet weak var usernameLbl: UILabel!
    
     override func viewDidLoad() {
        super.viewDidLoad()
      // self.showNavBackButton = true
    }


     override func viewWillAppear(_ animated: Bool) {
     }


    @IBAction func logout(_ sender: UIButton) {
        Globals.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    

}
