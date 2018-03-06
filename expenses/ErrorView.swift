//
//  ErrorView.swift
//  Example
//
//  Created by Alexander Schuch on 29/08/14.
//  Copyright (c) 2014 Alexander Schuch. All rights reserved.
//

import UIKit
import Material
class ErrorView: BasicPlaceholderView ,StatefulPlaceholderView{

	let textLabel = UILabel()
	let detailTextLabel = UILabel()
	let tapGestureRecognizer = UITapGestureRecognizer()
	
	override func setupView() {
		super.setupView()
		
		backgroundColor = Color.white
		
		self.addGestureRecognizer(tapGestureRecognizer)
		
		textLabel.text = "لايوجد اتصال بالانترنت"
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(textLabel)
		
		detailTextLabel.text = "اعادة تحميل"
		let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.footnote)
		detailTextLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
		detailTextLabel.textAlignment = .center
		detailTextLabel.textColor = UIColor.red
		detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
		centerView.addSubview(detailTextLabel)
		
		let views = ["label": textLabel, "detailLabel": detailTextLabel]
		let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[label]-|", options: .alignAllCenterY, metrics: nil, views: views)
		let hConstraintsDetail = NSLayoutConstraint.constraints(withVisualFormat: "|-[detailLabel]-|", options: .alignAllCenterY, metrics: nil, views: views)
		let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-[detailLabel]-|", options: .alignAllCenterX, metrics: nil, views: views)
		
		centerView.addConstraints(hConstraints)
		centerView.addConstraints(hConstraintsDetail)
		centerView.addConstraints(vConstraints)
	}

    
    func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
