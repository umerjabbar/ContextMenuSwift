//
//  ContextMenuTextCell.swift
//  
//
//  Created by Umer on 31/05/2023.
//

import UIKit

class ContextMenuTextCell: ContextMenuCell {
    
    lazy var titleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        return tLabel
    }()
    lazy var iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return imgView
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, iconImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        iconImageView.image = nil
        
    }
    
    open override func setup(){
        titleLabel.text = item.title
        if let menuConstants = style {
            titleLabel.textColor = menuConstants.LabelDefaultColor
            titleLabel.font = menuConstants.LabelDefaultFont
        }
        iconImageView.image = item.image
        iconImageView.isHidden = (item.image == nil)
    }
    
}
