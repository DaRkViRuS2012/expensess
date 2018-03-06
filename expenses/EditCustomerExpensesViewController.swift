//
//  EditCustomerExpensesViewController.swift
//  expenses
//
//  Created by Nour  on 11/11/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import DropDown
import Material
import Popover
class EditCustomerExpensesViewController: AbstractController ,CalendarViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var contactPersonTextField: UITextField!
    @IBOutlet weak var shippingAddressTextField: UITextField!
    @IBOutlet weak var billingAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var customersBtn: UIButton!
    
    
    let customersDropDown = DropDown()
    var customers:[Customer] = []
    var customersList:[String] = []
    
    var customerid:Int64?
    var selectedCustomer:Customer?
    
    var lines:[Line] = []
    
    var line:Line?
    var cellid = "LineCell"
    
    var header:Header?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadData),
                                               name: NSNotification.Name(rawValue: "loadData"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectCustomer),
                                               name: NSNotification.Name(rawValue: "selectCustomer"),
                                               object: nil)
    }
    
    
    
    func loadData(notification: Notification){
        lines = Globals.headerLines!
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func customizeView() {
        self.showNavBackButton = true
        let saveBtn =  UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save))
          let deleteBtn =  UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteHeader))
        self.navigationItem.rightBarButtonItems = [saveBtn, deleteBtn]
        dateButton.setTitle(dateFormatter.string(from: Date()), for: .normal)

        loadHeaderData()

        
        lines = (header?.HeaderLines)!
        Globals.headerLines = header?.HeaderLines
        
        let nib = UINib(nibName: cellid, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellid)
    }
    
    func deleteHeader(){
        self.header?.delete()
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    func loadHeaderData(){
    
        dateButton.setTitle(DateHelper.getStringFromDate((header?.headerCreatedDate)!), for: .normal)
        billingAddressTextField.text = header?.headerBillingAddress
        phoneNumberTextField.text = header?.headerPhoneNumber
        shippingAddressTextField.text = header?.headerShippingAddress
        contactPersonTextField.text = header?.headerContactPerson
        customersBtn.setTitle(header?.customer?.customerName, for: .normal)
        selectedCustomer = header?.customer
    }
    
    
    
    func validate()->Bool{
        
        
        let billingAddress = billingAddressTextField.text
        let phoneNumber = phoneNumberTextField.text
        let shippingAddress = shippingAddressTextField.text
        let contactPerson = contactPersonTextField.text
        
        
        if selectedCustomer == nil{
            showMessage(message: "select a customer", type: .error)
            return false
        }
        
        if !(phoneNumber?.isNumber)! || (phoneNumber?.isEmpty)!{
            showMessage(message: "enter a vaild phone number", type: .error)
            return false
        }
        
        
        
        if (shippingAddress?.isEmpty)!{
            showMessage(message: "enter shipping address", type: .error)
            return false
        }
        
        
        if (contactPerson?.isEmpty)!{
            showMessage(message: "enter contact Person", type: .error)
            return false
        }
        return true
        
    }
   
    
    func save(){
        
        let date = dateButton.currentTitle!
        let billingAddress = billingAddressTextField.text
        let phoneNumber = phoneNumberTextField.text
        let shippingAddress = shippingAddressTextField.text
        let contactPerson = contactPersonTextField.text
        if validate(){
        header?.headerCustomerId = self.selectedCustomer?.Id
        header?.headerCreatedDate = DateHelper.getDateFromString(date)!
        header?.headerBillingAddress = billingAddress
        header?.headerShippingAddress = shippingAddress
        header?.headerContactPerson = contactPerson
        header?.headerPhoneNumber = phoneNumber
        header?.save()
        
        self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LineSegue"{
            
            let vc = segue.destination as! CustomerExpensesLineViewController
            vc.customerid = customerid
            vc.customer = selectedCustomer
            vc.headerid = header?.id
        }
        
        if segue.identifier == "editCustomerSegue"{
            
            let vc = segue.destination as! EditCustomerExpensesLineViewController
            vc.headerid  = self.header?.id
            vc.customerid = self.header?.customer?.Id
            vc.customer = selectedCustomer
            vc.line = self.line
        }
    }
    
    func prepareCustomerList(){
        guard let user = Globals.user else {
            return
        }
        customers = user.getCustomers()
        customersList = customers.map({ $0.customerName })
        if customersList.count > 0 {
            customersBtn.setTitle(customersList[0], for: .normal)
            self.selectedCustomer = customers[0]
            //self.loadCustomerPrice()
        }
        
    }
    
    
    func prepareCustomerDropDown(){
        
        customersDropDown.anchorView = customersBtn
        customersDropDown.dataSource = customersList
        
        customersDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.customersBtn.setTitle(item, for: .normal)
            self.customerid = self.customers[index].Id
            self.selectedCustomer = self.customers[index]
            
        }
    }
    
    func selectCustomer(){
    
        if let customer = Globals.customer{
            customersBtn.setTitle(customer.customerName, for: .normal)
            selectedCustomer = customer
        }
    
    }
    
    
    @IBAction func toggleCustomerDropDown(_ sender: UIButton) {
        

        
         let vc = UIStoryboard.viewController(identifier: "CustomersViewController") as! CustomersViewController
        vc.selectMode = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func openCalendar(_ sender: UIButton) {
        let width = self.view.frame.width - 64
        let height = self.view.frame.height / 2
        let cv = CalendarView(frame: CGRect(x: 0, y: 0, width: width , height: height))
        cv.delegate = self
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: width , height: height))
        aView.addSubview(cv)
        
        let popover = Popover()
        popover.show(aView, fromView: self.dateButton)
    }
    
    
    func instanceFromNib() -> CalendarView {
        return UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CalendarView
    }
    
    
    
    func changeDate(date: Date) {
        let dateString = DateHelper.getStringFromDate(date)
        dateButton.setTitle(dateString, for: .normal)
    }
    
}

extension EditCustomerExpensesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! LineCell
        cell.line = lines[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


extension EditCustomerExpensesViewController:LineCellDelegate{
    
    func delete(line: Line) {
        lines = lines.filter({$0.Id != line.Id})
        Globals.headerLines =  Globals.headerLines?.filter({$0.Id != line.Id})
        line.delete()
        tableView.reloadData()
    }
    
    func edit(line: Line) {
        self.line = line
        self.performSegue(withIdentifier: "editCustomerSegue", sender: nil)
    }
}


