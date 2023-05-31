//
//  CustomCell.swift
//  ContextMenuSwiftDemo
//
//  Created by Umer Jabbar on 13/06/2020.
//  Copyright © 2020 Umer jabbar. All rights reserved.
//

import UIKit
import ContextMenuSwift

class CustomCell: ContextMenuCell {

    var action: ((Bool) -> Void)?
    
//    override func setup(item: ContextMenuItem, style: ContextMenuConstants? = nil) {
//        super.setup(contentView, tableView: tableView, item: item)
//    }
    
    @IBAction func switchTapAction(_ sender: UISwitch) {
        self.action?(sender.isOn)
        
        print("asd")
    }
    
}
