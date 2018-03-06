//
//  Section.swift
//  expenses
//
//  Created by Nour  on 8/3/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import Foundation


class Section {

    var date:Date!
    var items:[Item]!
    var total:Double!
    var expaded:Bool!
    
    
    init(date:Date,items:[Item],total:Double,expaded:Bool) {
        self.date = date
        self.items = items
        self.total = total
        self.expaded = expaded
    }




}
