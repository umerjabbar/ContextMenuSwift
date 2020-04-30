//
//  CustomFocusedView.swift
//  Seekr
//
//  Created by macmin on 29/04/2020.
//  Copyright © 2020 macmin. All rights reserved.
//

import UIKit

protocol MyMenuItem {
    var title : String {
        get
    }
    var image : UIImage? {
        get
    }
}

extension MyMenuItem {
    var image: UIImage? {
        get { return nil }
    }
}

extension String : MyMenuItem {
    var title: String {
        get {
            return "\(self)"
        }
    }
}
struct MyMenuItemWithImage: MyMenuItem {
    var title: String
    var image: UIImage? = nil
}

extension UIView {
    
    func showMenu(wind: UIWindow, items: [MyMenuItem], actionHandler: ((_ index: Int, _ item: MyMenuItem) -> Void)?){
        let cust = ContextMenuSwift(viewTargeted: self, window: wind)
        cust.items = items
        cust.responseHandler = { index, item in
            actionHandler?(index, item)
        }
        cust.showMenu()
    }
    
    func showMenu(items: [MyMenuItem], actionHandler: ((_ index: Int, _ item: MyMenuItem) -> Void)?){
        if let wind = UIApplication.shared.keyWindow {
            let cust = ContextMenuSwift(viewTargeted: self, window: wind)
            cust.items = items
            cust.responseHandler = { index, item in
                actionHandler?(index, item)
            }
            cust.showMenu()
        }
    }
    
}

struct MenuConstants {
    static var MaxZoom : CGFloat = 1.15
    static var MenuDefaultHeight : CGFloat = 120
    static var MenuWidth : CGFloat = 250
    static var MenuMarginSpace : CGFloat = 20
    static var TopMarginSpace : CGFloat = 64
    static var BottomMarginSpace : CGFloat = 20
    static var HorizontalMarginSpace : CGFloat = 20
    static var ItemDefaultHeight : CGFloat = 44
    
    static var LabelDefaultFont : UIFont = .systemFont(ofSize: 14)
    static var LabelDefaultColor : UIColor = UIColor.black.withAlphaComponent(0.95)
    static var ItemDefaultColor : UIColor = UIColor.white.withAlphaComponent(0.95)
    
    static var MenuCornerRadius : CGFloat = 12
    static var BlurEffectEnabled : Bool = true
    static var BlurEffectDefault : UIBlurEffect = UIBlurEffect(style: .dark)
    static var BackgroundViewColor : UIColor = UIColor.black.withAlphaComponent(0.6)
    
    
}

class ContextMenuSwift {
    
    var mainViewRect : CGRect
    
    var window : UIWindow
    var viewTargeted: UIView
    
    var customView = UIView()
    var blurEffectView = UIVisualEffectView()
    var closeButton = UIButton()
    var targetedImageView = UIImageView()
    var menuView = UIView()
    var scrollView = UIScrollView()
    var scrollViewConstraint : NSLayoutConstraint?
    
    var zoomedTargetedSize = CGRect()
    
    var menuHeight : CGFloat = 180
    
    var items = [MyMenuItem]()
    
    var responseHandler : ((_ index: Int, _ item: MyMenuItem) -> Void)?
    
    var placeHolderView : UIView?
    
    init(viewTargeted: UIView, window: UIWindow) {
        self.viewTargeted = viewTargeted
        self.window = window
        self.mainViewRect = window.frame
    }
    
    func showMenu(){
        if !window.subviews.contains(customView) {
            window.addSubview(customView)
        }
        customView.frame = CGRect(x: mainViewRect.origin.x, y: mainViewRect.origin.y, width: mainViewRect.width, height: mainViewRect.height)
        customView.backgroundColor = .clear
        
        if !items.isEmpty {
            self.menuHeight = CGFloat(items.count) * MenuConstants.ItemDefaultHeight + CGFloat(items.count - 1)
        }else{
            self.menuHeight = MenuConstants.MenuDefaultHeight
        }
        
        self.addBlurEffectView()
        self.addCloseButton()
        self.addMenuView()
        self.addTargetedImageView()
        
        self.onViewAppear()
    }
    
    func updateView(){
        DispatchQueue.main.async {
            if !self.items.isEmpty {
                self.menuHeight = CGFloat(self.items.count) * MenuConstants.ItemDefaultHeight + CGFloat(self.items.count - 1)
            }else{
                self.menuHeight = MenuConstants.MenuDefaultHeight
            }
            self.addMenuView()
            self.updateTargetedImageViewPosition()
        }
    }
    
    func getRenderedImage() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: viewTargeted.bounds.size)
        let viewSnapShotImage = renderer.image { ctx in
            viewTargeted.contentScaleFactor = 3
            viewTargeted.drawHierarchy(in: viewTargeted.bounds, afterScreenUpdates: false)
        }
        return viewSnapShotImage
    }
    
    func addBlurEffectView(){
        
        if !customView.subviews.contains(blurEffectView) {
            customView.addSubview(blurEffectView)
        }
        if MenuConstants.BlurEffectEnabled {
            blurEffectView.effect = MenuConstants.BlurEffectDefault
            blurEffectView.backgroundColor = .clear
        }else{
            blurEffectView.effect = nil
            blurEffectView.backgroundColor = MenuConstants.BackgroundViewColor
        }
        blurEffectView.frame = CGRect(x: mainViewRect.origin.x, y: mainViewRect.origin.y, width: mainViewRect.width, height: mainViewRect.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
    }
    
    func addCloseButton(){
        
        if !customView.subviews.contains(closeButton) {
            customView.addSubview(closeButton)
        }
        closeButton.frame = CGRect(x: mainViewRect.origin.x, y: mainViewRect.origin.y, width: mainViewRect.width, height: mainViewRect.height)
        closeButton.setTitle("", for: .normal)
        closeButton.actionHandler(controlEvents: .touchUpInside) {
            self.onViewDismiss()
        }
    }
    
    func addTargetedImageView(){
        
        if !customView.subviews.contains(targetedImageView) {
            customView.addSubview(targetedImageView)
        }
        
        let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
        
        targetedImageView.image = self.getRenderedImage()
        targetedImageView.frame = CGRect(x: rect.x,
                                         y: rect.y,
                                         width: viewTargeted.frame.width,
                                         height: viewTargeted.frame.height)
        targetedImageView.layer.shadowColor = UIColor.black.cgColor
        targetedImageView.layer.shadowRadius = 16
        targetedImageView.layer.shadowOpacity = 0
        targetedImageView.isUserInteractionEnabled = true
        
    }
    
    func addMenuView(){
        
        if !customView.subviews.contains(menuView) {
            customView.addSubview(menuView)
        }else{
            scrollView.removeFromSuperview()
            scrollView = UIScrollView()
        }
        
        let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
        
        menuView.backgroundColor = MenuConstants.ItemDefaultColor
        menuView.layer.cornerRadius = MenuConstants.MenuCornerRadius
        menuView.frame = CGRect(x: rect.x,
                                y: rect.y + viewTargeted.frame.height + MenuConstants.MenuMarginSpace,
                                width: MenuConstants.MenuWidth, height: menuHeight)
        menuView.alpha = 0
        
        scrollView.frame = menuView.bounds
        scrollView.clipsToBounds = true
        scrollView.isScrollEnabled = true
        menuView.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: MenuConstants.MenuWidth).isActive = true
        
        if let placeHolder = self.placeHolderView {
            if items.isEmpty {
                stackView.addArrangedSubview(placeHolder)
                placeHolder.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
            }else{
                placeHolder.removeFromSuperview()
            }
        }
        
        items.enumerated().forEach { index, actionItem in
            let btn = UIButton()
            stackView.addArrangedSubview(btn)
            btn.setTitle(actionItem.title, for: .normal)
            btn.setTitleColor(MenuConstants.LabelDefaultColor, for: .normal)
            btn.titleLabel?.textColor = MenuConstants.LabelDefaultColor
            if #available(iOS 11.0, *) {
                btn.contentHorizontalAlignment = .leading
            }
//            btn.font = 14
            btn.titleLabel?.font = MenuConstants.LabelDefaultFont
            if let img = actionItem.image {
                let iconImageView = UIImageView(image: img)
                menuView.addSubview(iconImageView)
                iconImageView.contentMode = .scaleAspectFit
                iconImageView.translatesAutoresizingMaskIntoConstraints = false
                iconImageView.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -14).isActive = true
                iconImageView.heightAnchor.constraint(equalToConstant: 19).isActive = true
                iconImageView.widthAnchor.constraint(equalToConstant: 19).isActive = true
                iconImageView.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 14 + 19 + 12)
            }else{
                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
            btn.actionHandler(controlEvents: .touchUpInside) {
                btn.backgroundColor = .clear
                self.responseHandler?(index, actionItem)
                self.onViewDismiss()
            }
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.heightAnchor.constraint(equalToConstant: MenuConstants.ItemDefaultHeight).isActive = true
            btn.actionHandler(controlEvents: .touchDown) {
                btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            }
            btn.actionHandler(controlEvents: .touchUpOutside) {
                btn.backgroundColor = .clear
            }
            btn.actionHandler(controlEvents: .touchCancel) {
                btn.backgroundColor = .clear
            }
            
            if (items.count - 1) != index {
                let lineView = UIView()
                stackView.addArrangedSubview(lineView)
                lineView.translatesAutoresizingMaskIntoConstraints = false
                lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            }
        }
        
    }
    
    
    
    func onViewAppear(){
        viewTargeted.alpha = 0
        blurEffectView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.blurEffectView.alpha = 1
            self.targetedImageView.layer.shadowOpacity = 0.2
        }
        
        self.updateTargetedImageViewPosition()
    }
    
    func onViewDismiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView.alpha = 0
            self.targetedImageView.layer.shadowOpacity = 0
        }) { (_) in
            self.viewTargeted.alpha = 1
            self.customView.removeFromSuperview()
        }
        let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 8, options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
            self.menuView.alpha = 0
            self.targetedImageView.frame = CGRect(x: rect.x, y: rect.y, width: self.viewTargeted.frame.width, height: self.viewTargeted.frame.height)
            self.menuView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)//.translatedBy(x: 0, y: (self.menuHeight) * CGFloat((rect.y < self.menuView.frame.origin.y) ? -1 : 1) )
        }) { (_) in
            
        }
    }
    
    func getZoomedTargetedSize() -> CGRect{
        
        let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
        let targetedImageFrame = viewTargeted.frame
        
        let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
        let zoomFactor = ((backgroundWidth/targetedImageFrame.width) < MenuConstants.MaxZoom) ? (backgroundWidth/targetedImageFrame.width) : MenuConstants.MaxZoom
        
        let updatedWidth = (targetedImageFrame.width * zoomFactor)
        let updatedHeight = (targetedImageFrame.height * zoomFactor)
        
        let updatedX = rect.x - (updatedWidth - targetedImageFrame.width)/2
        let updatedY = rect.y - (updatedHeight - targetedImageFrame.height )/2
        
        return CGRect(x: updatedX, y: updatedY, width: updatedWidth, height: updatedHeight)
        
    }
    
    
    func updateTargetedImageViewPosition(){
        
        let targetedImagePosition = getZoomedTargetedSize()
        
        let tvH = targetedImagePosition.height
        let tvW = targetedImagePosition.width
        var tvY = targetedImagePosition.origin.y
        var tvX = targetedImagePosition.origin.x
        
        var mH = menuHeight
        let mW = MenuConstants.MenuWidth
        var mY = tvY + MenuConstants.MenuMarginSpace
        var mX = MenuConstants.HorizontalMarginSpace
        
        if tvY > mainViewRect.height - MenuConstants.BottomMarginSpace - tvH {
            tvY = mainViewRect.height - MenuConstants.BottomMarginSpace - tvH
        }
        else if tvY < MenuConstants.TopMarginSpace {
            tvY = MenuConstants.TopMarginSpace
        }
        
        if tvX < MenuConstants.HorizontalMarginSpace {
            tvX = MenuConstants.HorizontalMarginSpace
            mX = MenuConstants.HorizontalMarginSpace
        }
        else if tvX > mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW {
            tvX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW
            mX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - mW
        }
        else{
            if ((mainViewRect.width/2) - (mX + mW/2))/mainViewRect.width <= 0.2  {
                mX = mainViewRect.width/2 - mW/2
            }else{
                mX = MenuConstants.HorizontalMarginSpace
            }
        }
        
        let bottomClippedSpace = (tvH + MenuConstants.MenuMarginSpace + mH + tvY + MenuConstants.BottomMarginSpace) - mainViewRect.height
        let topClippedSpace = -(tvY - MenuConstants.MenuMarginSpace - mH - MenuConstants.TopMarginSpace)
        
        // not enought space down
        
        if topClippedSpace > 0, bottomClippedSpace > 0 {
            
            let diffY = mainViewRect.height - (mH + MenuConstants.MenuMarginSpace + tvH + MenuConstants.TopMarginSpace + MenuConstants.BottomMarginSpace)
            if diffY > 0 {
                if (tvY + tvH/2) > mainViewRect.height/2 { //down
                    tvY = tvY + topClippedSpace
                    mY = tvY - MenuConstants.MenuMarginSpace - mH
                }else{ //up
                    tvY = tvY - bottomClippedSpace
                    mY = tvY + MenuConstants.MenuMarginSpace + tvH
                }
            }else{
                if (tvY + tvH/2) > mainViewRect.height/2 { //down
                    tvY = mainViewRect.height - MenuConstants.BottomMarginSpace - tvH
                    mY = MenuConstants.TopMarginSpace
                    mH = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace - MenuConstants.MenuMarginSpace - tvH
                }else{ //up
                    tvY = MenuConstants.TopMarginSpace
                    mY = tvY + tvH + MenuConstants.MenuMarginSpace
                    mH = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace - MenuConstants.MenuMarginSpace - tvH
                }
            }
        }
        else if bottomClippedSpace > 0 {
            mY = tvY - MenuConstants.MenuMarginSpace - mH
        }
        else if topClippedSpace > 0  {
            mY = tvY + MenuConstants.MenuMarginSpace  + tvH
        }
        else{
            mY = tvY + MenuConstants.MenuMarginSpace + tvH
        }
        
        scrollView.frame = menuView.bounds
        scrollView.frame = CGRect(x: 0, y: 0, width: mW, height: mH)
        scrollView.layoutIfNeeded()
        
        menuView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0).translatedBy(x: 0, y: (menuHeight) * CGFloat((tvY < mY) ? -1 : 1) )
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
            
            self.menuView.alpha = 1
            self.menuView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1).translatedBy(x: 0, y: 0)
            self.menuView.frame = CGRect(x: mX,
                                         y: mY,
                                         width: mW,
                                         height: mH)
            
            self.targetedImageView.frame = CGRect(x: tvX,
                                                  y: tvY,
                                                  width: tvW,
                                                  height: tvH)
            
        })
        
    }
}

@objc class ClosureSleeve: NSObject {
    let closure: () -> Void

    init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func actionHandler(controlEvents control: UIControl.Event = .touchUpInside, ForAction action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: control)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
