//
//  titleCell.swift
//  expenses
//
//  Created by Nour  on 10/4/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

protocol uomCellDelegate {
    func edit(uom:UoM)
    func delete(uom:UoM)
}

protocol currencyCellDelegate {
    func edit(currency:Currency)
    func delete(currency:Currency)
}


class titleCell: UITableViewCell {

    var uomdelegate:uomCellDelegate?
    var currencydelegate:currencyCellDelegate?
    
    @IBOutlet weak var titleLbl: UILabel!
    
    var currency:Currency?{
        didSet{
            guard let currency = currency else {
                return
            }
            
            titleLbl.text = currency.title
        }
    }
    
    var uom:UoM?{
        didSet{
            guard let uom = uom else{
            
                return
            }
            
            titleLbl.text = uom.title
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
        if let uom = uom{
            uomdelegate?.edit(uom: uom)
        }else if let currency = currency{
            
            currencydelegate?.edit(currency: currency)
        }
        
        
    }
    
    @IBAction func remove(_ sender: UIButton) {
        if let uom = uom{
            uomdelegate?.delete(uom: uom)
        }else if let currency = currency{
            
            currencydelegate?.delete(currency: currency)
        }
        
        
    }
    
}
