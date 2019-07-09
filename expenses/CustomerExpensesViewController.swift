
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

class CustomerExpensesViewController: AbstractController,UITableViewDelegate,UITableViewDataSource,ExpandableHeaderViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var dateFilterSegmentedControl: UISegmentedControl!
    
    var filterType = "Monthly"
    
    
    let cellid = "expensesCell"
    
    let dropDown = DropDown()
    
    var currentdate:Date = Date()
    var headers:[Header]  = []
    
    var filteredHeaders:[Header] = []
    
    var isFillter = false
    var header:Header?
    
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
    
    var currentDate = DateHelper.getStringFromShortDate(Date())
    let items:[[Header]] = []
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
        prepareView()
        prepareDropDown()
        loadData()
    }
    
    func prepareView(){
        
        let nib = UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
        
        let addbtn =  UIBarButtonItem(image: Icon.addCircle, style: .plain, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addbtn
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func fillter(customerName:String){
        if customerName == "All" {
            isFillter = false
            tableView.reloadData()
            return
        }
        filteredHeaders = headers.filter({$0.customer?.customerName == customerName })
        isFillter = true
        tableView.reloadData()
    }
    
    func loadData(){
        
        guard let user = Globals.user else{
            return
        }
        
        headers = user.getCustomerHeaders(date:currentdate,type:filterType).filter({$0.deleted != true})
        let customer = self.categoryBtn.currentTitle
        fillter(customerName: customer!)
    }
    
    
    
    func close() {
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    @objc func add(){
        let vc = UIStoryboard.viewController(identifier: "NewCustomerExpensesViewController") 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func prepareDropDown(){
        
        
        dropDown.anchorView = categoryBtn // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        guard let user = Globals.user else{
            return
        }
        let customers  = user.getCustomers()
        var customersNames = customers.map({ $0.customerName })
        customersNames.insert("All", at: 0)
        dropDown.dataSource = customersNames as! [String]
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.categoryBtn.setTitle(item, for: .normal)
            self.fillter(customerName: item)
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
        
        
        let vc = UIStoryboard.viewController(identifier: "NewCustomerExpensesViewController") as! NewCustomerExpensesViewController
        vc.header = header
        vc.editMode = true
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: "editCustomerLineSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCustomerLineSegue"{
        
        let vc = segue.destination as! EditCustomerExpensesViewController
        vc.header  = self.header
        
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFillter {
            return filteredHeaders.count
        }
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFillter {
            return  filteredHeaders[section].HeaderLines.count
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
            return 0
        }
        if headers[indexPath.section].expaded == true{
            return 70
        }
        
        return 0
        
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
