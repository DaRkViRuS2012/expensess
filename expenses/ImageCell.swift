//
//  ImageCell.swift
//  expenses
//
//  Created by Nour  on 8/9/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

protocol ImageCellDelegate {
    func delete(image:Image)
    
}


class ImageCell: UICollectionViewCell {
    var delegate:ImageCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    var image:Image?{
        didSet{
        
            guard let image = image else {
                return
            }
            
            imageView.image = image.image
        
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    @IBAction func remove(_ sender: UIButton) {
        delegate?.delete(image: image!)
        
    }
    
    
    
    

}
