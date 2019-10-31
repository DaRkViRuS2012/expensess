
//
//  ExpandableHeaderView.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header:ExpandableHeaderView,section:Int)
    func edit(section:Int)
}


enum ExpensesState:Int{
    case pendding = 1
    case rejected = 3
    case approved = 2
    
    var color:UIColor{
        switch(self){
        case .pendding:
            return .orange
        case .rejected:
            return .red
        case .approved:
            return .green
    
        }
    }
    var state:Int{
        switch(self){
        case .pendding:
            return 1
        case .rejected:
            return 3
        case .approved:
            return 2
        }
    }
}

class ExpandableHeaderView: UITableViewHeaderFooterView {

    var delegate:ExpandableHeaderViewDelegate?
    var section:Int!
    
    
    var dayNum:UILabel = {
        let l = UILabel()
        l.textColor = .red
        l.font = UIFont.systemFont(ofSize: 12)
        return l
    }()
    
    var dayName:UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 12)
        return l
        
    }()
    
    var total:UILabel = {
        
        let l = UILabel()
        l.textColor = .red
        l.text = "18.45$"
        l.font = UIFont.systemFont(ofSize: 12)
        return l
        
    }()
    
    var stateView:UIView = {
        let v = UIView()
        
        v.layer.cornerRadius = 6
        v.backgroundColor = .red
        return v
    }()
    
    
    var editButton:UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "edit icon"), for: .normal)
        return btn
    
    }()
    
    
    fileprivate lazy var daydateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MMM.yyyy"
        return formatter
    }()
    
    
    
    fileprivate lazy var dayNumdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareView()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelSelect)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handelSelect(gestureRecognizer:UITapGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    
    }
    
    func customInit(date:String,section:Int,total:Double,state:ExpensesState,delegate:ExpandableHeaderViewDelegate){
    
        self.dayName.text = date //daydateFormatter.string(from: date)
        self.total.text = "\(total)"
        self.section = section
        self.delegate = delegate
        self.stateView.backgroundColor = state.color
        if state == .pendding{
            self.editButton.isHidden = false
        }else{
            self.editButton.isHidden = true
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor(white: 0.8, alpha: 1)
    }
    
    func prepareView(){
    self.addSubview(dayName)
    self.addSubview(total)
    self.addSubview(editButton)
    self.addSubview(stateView)
  
     
     
        _ = dayName.anchor8(self, topattribute: .top, topConstant: 0, leftview: self, leftattribute: .leading, leftConstant: 32, bottomview: self, bottomattribute: .bottom, bottomConstant: 0, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = stateView.anchor8(self, topattribute: .top, topConstant: 20, leftview: self, leftattribute: .leading, leftConstant: 8, bottomview: nil, bottomattribute: .bottom, bottomConstant: 0, rightview: nil, rightattribute: nil, rightConstant: 0, widthConstant: 12, heightConstant: 12)
  
        _ = total.anchor8(self, topattribute: .top, topConstant: 0, leftview: nil, leftattribute: nil, leftConstant: 0, bottomview: self, bottomattribute: .bottom, bottomConstant: 0, rightview: editButton, rightattribute: .leading, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        
        
       _ = editButton.anchor8(self, topattribute: .top, topConstant: 8, leftview: nil, leftattribute: nil, leftConstant: 0, bottomview: nil, bottomattribute: .bottom, bottomConstant: 0, rightview: self, rightattribute: .trailing, rightConstant: 16, widthConstant: 25, heightConstant: 25)
        
        
        editButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        
    }
    
    @objc func edit(){
        self.delegate?.edit(section: section)
    }
 
}
