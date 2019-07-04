//
//  ItemCell.swift
//  expenses
//
//  Created by Nour  on 8/4/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit


protocol ItemCellDelegate {
    func delete(item:Item)
    func edit(item:Item)
  
}


protocol LineCellDelegate {
    func delete(line:Line)
    func edit(line:Line)
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discreptionLabel: UILabel!
   
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deletButton: UIButton!
    
    func selectMode(){
        editButton.isHidden = true
        deletButton.isHidden = true
    }
    
    var item:Item?{
        
    didSet{
                guard let item = item else{
                    return
                }
            
            titleLabel.text = item.title
            discreptionLabel.text = item.code
            if let price = item.price{
                costLabel.text = "\(price)"
            }
            
        }
        
    }
    
    var delegate:ItemCellDelegate?
    var lineDelegate:LineCellDelegate?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    @IBAction func remove(_ sender: UIButton) {
        if let item = item{
            delegate?.delete(item: item)
        }
    }
    
    @IBAction func edit(_ sender: UIButton) {
        if let item = item{
            delegate?.edit(item: item)
        }
    }
    
}
