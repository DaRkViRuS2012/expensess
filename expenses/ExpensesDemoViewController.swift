//
//  ExpensesDemoViewController.swift
//  expenses
//
//  Created by Nour  on 8/6/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import FSCalendar
class ExpensesDemoViewController: AbstractController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {

    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        // Do any additional setup after loading the view.
        
        
         prepareViewState()
    }

    let mainColor = UIColor(red: 84/255, green: 193/255, blue: 188/255, alpha: 1)
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00"
        return formatter
    }()
    
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        return cell!
        
    }
    
    var lodingView:LoadingView = {
        let v = LoadingView()
        return v
    }()
    
    var emptyView:EmptyView = {
        let v = EmptyView()
        return v
    }()
    
    var wrongView:ErrorView = {
        let v = ErrorView()
        return v
    }()
    
    
    func prepareViewState(){
        view.addSubview(lodingView)
        view.addSubview(wrongView)
        view.addSubview(emptyView)
     //   lodingView.anchorToTop8(buttonsView, leftview: view, bottomview: view, rightview: view)
        emptyView.detailTextLabel.isHidden = true
        emptyView.textLabel.text = "No Appointments"
        
//wrongView.anchorToTop8(buttonsView, leftview: view, bottomview: view, rightview: view)
    //    emptyView.anchorToTop8(buttonsView, leftview: view, bottomview: view, rightview: view)
        //emptyView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        
       // wrongView.tapGestureRecognizer.addTarget(self, action: #selector(loadData))
        initilze()
    }
    
    func initilze(){
        
        lodingView.isHidden = true
        wrongView.isHidden = true
        emptyView.isHidden = true
    }
    
    func loding(){
        lodingView.isHidden = false
        wrongView.isHidden = true
        emptyView.isHidden = true
    }
    
    func error(){
        lodingView.isHidden = true
        wrongView.isHidden = false
        emptyView.isHidden = true
    }
    func empty(){
        
        lodingView.isHidden = true
        wrongView.isHidden = true
        emptyView.isHidden = false
    }
    
    



}
