
//
//  EmployeeExpensesViewController.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
import DropDown

class EmployeeExpensesViewController: AbstractController,UITableViewDelegate,UITableViewDataSource,ExpandableHeaderViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var dateLbl: UILabel!
    
    
    @IBOutlet weak var categoryBtn: UIButton!
      @IBOutlet weak var dateFilterSegmentedControl: UISegmentedControl!
    var filterType = "Monthly"
    
    
    
    var filteredHeaders:[Header] = []
    
    var isFillter = false
    
    let cellid = "expensesCell"
    
    let dropDown = DropDown()
    
    var currentdate:Date = Date()
    
    var itemsList:[String] = []
    
    var headers:[Header]  = []
    
    var header:Header?
    
    var currentDate = DateHelper.getStringFromShortDate(Date())
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM"
        return formatter
    }()
    
    fileprivate lazy var yeardateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    fileprivate lazy var daydateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MMM.yyyy"
        return formatter
    }()
    
    
    @IBAction func changeDateFilter(_ sender: UISegmentedControl) {
        filterType = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        update()
    }
    
    
    func update(){
        var date = dateFormatter.string(from: currentdate)
        if filterType == "Yearly"{
            date = yeardateFormatter.string(from: currentdate)
        }
        dateLbl.text = date
        loadData()
    }
    
    
    func fillter(title:String){
        if title == "All" {
            isFillter = false
            tableView.reloadData()
            return
        }
        filteredHeaders = headers.filter({$0.HeaderLines[0].item?.title == title })
        isFillter = true
        tableView.reloadData()
    }
    
    func getItemsList(){
    
        self.itemsList = (Globals.user?.getEmployeeItems().map({$0.title}))! as! [String]
        self.itemsList.insert("All", at: 0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        
      
        let nib = UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        
        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addbtn
        //self.showNavBackButton = true
        getItemsList()
        prepareDropDown()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
    
        guard let user = Globals.user else{
            return
        }
        headers = user.getEmployeeHeaders(date: currentdate, type: filterType).filter({$0.deleted != true})
        let title = self.categoryBtn.currentTitle
        fillter(title: title!)
    }
    
    func close() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func add(){
        let vc = UIStoryboard.viewController(identifier: "NewEmployeeExpensesViewController") as! NewEmployeeExpensesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func prepareDropDown(){
    
    
        dropDown.anchorView = categoryBtn // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        
        dropDown.dataSource = self.itemsList
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.categoryBtn.setTitle(item, for: .normal)
            self.fillter(title: item)
        }
        
        // Will set a custom width instead of the anchor view width
     //   dropDownLeft.width = 200
    }

    
    func getnext(){
        if filterType == "Monthly"{
            currentdate =  currentdate.getNextMonth()!
        }else{
            
            currentdate = currentdate.addingTimeInterval(31104000)
        }
        update()
    }
    
    func getpreve(){
        
        if filterType == "Monthly"{
            currentdate = currentdate.getPreviousMonth()!
        }else{
            
            currentdate = currentdate.addingTimeInterval(-31104000)
        }
        
        update()
    }

    @IBAction func next(_ sender: UIButton) {
       getnext()
    }
    
    @IBAction func prev(_ sender: UIButton) {
       getpreve()
    }
    
    @IBAction func swipRight(_ sender: UISwipeGestureRecognizer) {
       getpreve()
    }
    
    @IBAction func swipLeft(_ sender: UISwipeGestureRecognizer) {
       getnext()
    }
    
    
    
    @IBAction func toggelDropDown(_ sender: UIButton) {
        if dropDown.isHidden{
        dropDown.show()
        }else{
        dropDown.hide()
        }
        
    }
    

    func edit(section: Int) {
        if isFillter {
            self.header = self.filteredHeaders[section]
            
        }else{
            self.header = self.headers[section]
        }
        
        let vc = UIStoryboard.viewController(identifier: "NewEmployeeExpensesViewController") as! NewEmployeeExpensesViewController
        vc.header = header
        vc.editMode = true
        //self.performSegue(withIdentifier: "editEmployeeLineSegue", sender: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEmployeeLineSegue"{
            
            let vc = segue.destination as! EditEmployeeExpensesViewController
            vc.header  = self.header
        }
    }
    
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFillter{
        return filteredHeaders.count
        }
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFillter{
            return filteredHeaders[section].HeaderLines.count
        }
        return headers[section].HeaderLines.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFillter{
            if filteredHeaders[indexPath.section].expaded == true{
                return 70
            }
            else{
                return 0
            }
        }else{
        if headers[indexPath.section].expaded == true{
            return 70
        }
        else{
        return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        var total:Double = 0.0
        if isFillter{
            for line  in filteredHeaders[section].HeaderLines{
                total += line.Amount
            }
            
        }else{
            for line  in headers[section].HeaderLines{
                total += line.Amount
            }
            
        }
        
        if isFillter{
            
            let state = ExpensesState(rawValue: filteredHeaders[section].headerStatus!)
            header.customInit(date: DateHelper.getStringFromDate(filteredHeaders[section].headerCreatedDate!)!,section: section , total:total,state: state!, delegate: self)
            
        }else{
            
            let state = ExpensesState(rawValue: headers[section].headerStatus!)
            header.customInit(date: DateHelper.getStringFromDate(headers[section].headerCreatedDate!)!, section: section,total:total,state: state!, delegate: self)
        }
        return header
    }
        
          
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! expensesCell
        print("row :\(indexPath.row)")
        if isFillter{
            cell.line = filteredHeaders[indexPath.section].HeaderLines[indexPath.row]
        }else{
            cell.line = headers[indexPath.section].HeaderLines[indexPath.row]
        }
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        if isFillter {
            filteredHeaders[section].expaded = !filteredHeaders[section].expaded
            tableView.beginUpdates()
            
            for i in 0..<filteredHeaders[section].HeaderLines.count {
                print("i :\(i)")
                print("section :\(section)")
                tableView.reloadRows(at: [IndexPath(row:i,section:section)], with: .automatic)
                
            }
            tableView.endUpdates()
        }else{
            headers[section].expaded = !headers[section].expaded
            tableView.beginUpdates()
            
            for i in 0..<headers[section].HeaderLines.count {
                print("i :\(i)")
                print("section :\(section)")
                tableView.reloadRows(at: [IndexPath(row:i,section:section)], with: .automatic)
                
            }
            tableView.endUpdates()
        }
    }
    
}
