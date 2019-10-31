//
//  ViewController.swift
//  expenses
//
//  Created by Nour  on 8/1/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import SQLite
import CVCalendar

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.]
               self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
//        calendarView.commitCalendarViewUpdate()
    }


}

