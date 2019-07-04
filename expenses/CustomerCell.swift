//
//  CustomerCell.swift
//  expenses
//
//  Created by Nour  on 10/4/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit



protocol CustomerCellDelegate {
    func edit(customer:Customer)
    func delete(customer:Customer)
}

class CustomerCell: UITableViewCell {

    var delegate:CustomerCellDelegate?
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deletButton: UIButton!
    
    func selectMode(){
        editButton.isHidden = true
        deletButton.isHidden = true
    }
    
    
    var customer:Customer?{
    
        didSet{
        
            guard let customer = customer else{
                return
            }
        
            nameLbl.text = customer.customerName
            if let code = customer.customerCode{
                codeLbl.text = "No: \(code)"
                
            }
            currencyLbl.text = customer.customerCurrency
            
        }
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func edit(_ sender: UIButton) {
        delegate?.edit(customer: customer!)
    }
    
    @IBAction func remove(_ sender: UIButton) {
        delegate?.delete(customer: customer!)
    }
    
}
