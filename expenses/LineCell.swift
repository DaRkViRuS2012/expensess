//
//  LineCell.swift
//  expenses
//
//  Created by Nour  on 11/9/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit


class LineCell: UITableViewCell {

    var delegate:LineCellDelegate?
    
    var line:Line?{
    
        didSet{
        
            guard let line = line else {
                return
            }
            
            self.descLabel.text = line.item?.title
            self.qntyLabel.text = "\(line.LinePrice ?? 0)*\(line.Qty ?? 1) \(line.LineUoM ?? "")"
            self.priceLabel.text = "\(line.Amount ?? 0) \(line.currency ?? "")" 
        }
    
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qntyLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func remove(_ sender: UIButton) {
        delegate?.delete(line: self.line!)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        delegate?.edit(line: self.line!)
    }
}
