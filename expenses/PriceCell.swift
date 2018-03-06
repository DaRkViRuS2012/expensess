//
//  PriceCell.swift
//  expenses
//
//  Created by Nour  on 10/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit



protocol PriceCellDelegate {
    func delete(price:Price)
    func edit(price:Price)
}


class PriceCell: UITableViewCell {

    var delegate:PriceCellDelegate?
    
    @IBOutlet weak var ItemLbl: UILabel!
    @IBOutlet weak var customerLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    
    
    
    var price:Price?{
    
        didSet{
        
        
            guard let price = price else{
                return
            }
            ItemLbl.text = price.item?.title
            customerLbl.text = price.customer?.customerName
            PriceLbl.text = price.value
        
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
        delegate?.edit(price: self.price!)
    }
    
    
    @IBAction func remove(_ sender: UIButton) {
        delegate?.delete(price: self.price!)
    }
   
    
}
