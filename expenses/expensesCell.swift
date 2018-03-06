//
//  expensesCell.swift
//  expenses
//
//  Created by Nour  on 11/10/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

class expensesCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discreptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    var line:Line?{
    
        didSet{
            guard let line = line else{
                return
            }
        
            titleLabel.text = line.item?.title
            discreptionLabel.text = line.ItemDiscription
            
            
            dateLabel.text = DateHelper.getStringFromDate((line.header?.headerCreatedDate)!)
            if let customer = line.header?.customer{
                customerNameLabel.text = customer.customerName
            }else{
                customerNameLabel.text = ""
            }
            
            costLabel.text = "\(line.LinePrice) \(line.currency)"
            
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
    
}
