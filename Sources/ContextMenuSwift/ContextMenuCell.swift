//
//  ContextMenuTVC.swift
//  ContextMenuSwift
//
//  Created by Umer Jabbar on 13/06/2020.
//  Copyright © 2020 Umer jabbar. All rights reserved.
//

import UIKit

open class ContextMenuCell: UITableViewCell {
    
    static let identifier = "ContextMenuCell"
    
    public weak var contextMenu: ContextMenu?
    public weak var tableView: UITableView?
    public var item: ContextMenuItem!
    public var style : ContextMenuConstants? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        } else{
            self.contentView.backgroundColor = .clear
        }
    }
    
    open func commonInit() {

    }
    
    open func setup(){
        
    }
    
}
