//
//  CustomFocusedView.swift
//  Seekr
//
//  Created by macmin on 29/04/2020.
//  Copyright © 2020 macmin. All rights reserved.
//

import UIKit

public protocol ContextMenuItem {
    var title : String {
        get
    }
    var image : UIImage? {
        get
    }
}

extension ContextMenuItem {
    public var image: UIImage? {
        get { return nil }
    }
}

extension String : ContextMenuItem {
    public var title: String {
        get {
            return "\(self)"
        }
    }
}
public struct ContextMenuItemWithImage: ContextMenuItem {
    public var title: String
    public var image: UIImage?
    
    public init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
}

//extension UIView {
//
//    open func showMenu(wind: UIWindow, items: [ContextMenuItem], actionHandler: ((_ index: Int, _ item: ContextMenuItem) -> Bool)?){
//        let cust = ContextMenu(viewTargeted: self, window: wind)
//        cust.items = items
//        cust.onItemTap = { index, item in
//            (actionHandler?(index, item) ?? true)
//        }
//        cust.showMenu()
//    }
//
//    open func showMenu(items: [ContextMenuItem], actionHandler: ((_ index: Int, _ item: ContextMenuItem) -> Bool)?){
//        if let cust = ContextMenu(viewTargeted: self) {
//            cust.items = items
//            cust.onItemTap = { index, item in
//                (actionHandler?(index, item) ?? true)
//            }
//            cust.showMenu()
//        }
//    }
//
////    open func getContextMenu(window: UIView? = nil) -> ContextMenu?{
////        return ContextMenu(viewTargeted: self, window: window)
////    }
////
//}

public protocol ContextMenuDelegate : AnyObject {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int)
    func contextMenuDidAppear(_ contextMenu: ContextMenu)
    func contextMenuDidDisappear(_ contextMenu: ContextMenu)
}
extension ContextMenuDelegate {
    func contextMenuDidAppear(_ contextMenu: ContextMenu){}
    func contextMenuDidDisappear(_ contextMenu: ContextMenu){}
}

public var CM : ContextMenu = ContextMenu()

public struct ContextMenuConstants {
    public var MaxZoom : CGFloat = 1.15
    public var MinZoom : CGFloat = 0.6
    public var MenuDefaultHeight : CGFloat = 120
    public var MenuWidth : CGFloat = 250
    public var MenuMarginSpace : CGFloat = 20
    public var TopMarginSpace : CGFloat = 40
    public var BottomMarginSpace : CGFloat = 24
    public var HorizontalMarginSpace : CGFloat = 20
    public var ItemDefaultHeight : CGFloat = 44
//    var headerDefaultHeight : CGFloat = 0
//    var footerDefaultHeight : CGFloat = 0
    
    public var LabelDefaultFont : UIFont = .systemFont(ofSize: 14)
    public var LabelDefaultColor : UIColor = UIColor.black.withAlphaComponent(0.95)
    public var ItemDefaultColor : UIColor = UIColor.white.withAlphaComponent(0.95)
    
    public var MenuCornerRadius : CGFloat = 12
    public var BlurEffectEnabled : Bool = true
    public var BlurEffectDefault : UIBlurEffect = UIBlurEffect(style: .dark)
    public var BackgroundViewColor : UIColor = UIColor.black.withAlphaComponent(0.6)
    
    public var DismissOnItemTap : Bool = false
}

open class ContextMenu: NSObject {
    
    // MARK:- open Variables
    open var MenuConstants = ContextMenuConstants()
    open var viewTargeted: UIView!
    open var placeHolderView : UIView?
    open var headerView : UIView?
    open var footerView : UIView?
    open var nibView = UINib(nibName: ContextMenuCell.identifier, bundle: Bundle(for: ContextMenuCell.self))
    open var closeAnimation = true
    
    open var onItemTap : ((_ index: Int, _ item: ContextMenuItem) -> Bool)?
    open var onViewAppear : ((UIView) -> Void)?
    open var onViewDismiss : ((UIView) -> Void)?
    
    open var items = [ContextMenuItem]()
    
    // MARK:- Private Variables
    private weak var delegate : ContextMenuDelegate?
    
    private var mainViewRect : CGRect
    private var customView = UIView()
    private var blurEffectView = UIVisualEffectView()
    private var closeButton = UIButton()
    private var targetedImageView = UIImageView()
    private var menuView = UIView()
    public var tableView = UITableView()
    private var tableViewConstraint : NSLayoutConstraint?
    private var zoomedTargetedSize = CGRect()
    
    private var menuHeight : CGFloat = 180
    private var isLandscape : Bool = false
    
    private var touchGesture : UITapGestureRecognizer?
    private var closeGesture : UITapGestureRecognizer?
    
    private var tvH : CGFloat = 0.0
    private var tvW : CGFloat = 0.0
    private var tvY : CGFloat = 0.0
    private var tvX : CGFloat = 0.0
    private var mH : CGFloat = 0.0
    private var mW : CGFloat = 0.0
    private var mY : CGFloat = 0.0
    private var mX : CGFloat = 0.0
    
    // MARK:- Init Functions
    public init(window: UIView? = nil) {
        let wind = window ?? UIApplication.shared.windows.first ?? UIApplication.shared.keyWindow
        self.customView = wind!
        self.mainViewRect = wind!.frame
    }
    
    init?(viewTargeted: UIView, window: UIView? = nil) {
        if let wind = window ?? UIApplication.shared.windows.first ?? UIApplication.shared.keyWindow {
            self.customView = wind
            self.viewTargeted = viewTargeted
            self.mainViewRect = self.customView.frame
        }else{
            return nil
        }
    }
    
    init(viewTargeted: UIView, window: UIView) {
        self.viewTargeted = viewTargeted
        self.customView = window
        self.mainViewRect = window.frame
    }
    
    deinit {
//        removeTapInteraction()
        print("Deinit")
    }
    
//    open func addTapInteraction(){
//        self.viewTargeted.isUserInteractionEnabled = true
//        touchGesture = UITapGestureRecognizer(target: self, action: #selector(self.itemTapped(_:)))
//        self.viewTargeted.addGestureRecognizer(touchGesture!)
//    }
//
//    open func removeTapInteraction(){
//        if let gesture = self.touchGesture {
//            self.viewTargeted.removeGestureRecognizer(gesture)
//            self.viewTargeted.isUserInteractionEnabled = false
//            self.touchGesture = nil
//        }
//    }
//
//    @objc func itemTapped(_ sender: UITapGestureRecognizer? = nil){
//        DispatchQueue.main.async {
//            self.showMenu()
//        }
//    }
    
    // MARK:- Show, Change, Update Menu Functions
    open func showMenu(viewTargeted: UIView, delegate: ContextMenuDelegate, animated: Bool = true){
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        DispatchQueue.main.async {
            self.delegate = delegate
            self.viewTargeted = viewTargeted
            if !self.items.isEmpty {
                self.menuHeight = (CGFloat(self.items.count) * self.MenuConstants.ItemDefaultHeight) + (self.headerView?.frame.height ?? 0) + (self.footerView?.frame.height ?? 0) // + CGFloat(self.items.count - 1)
            }else{
                self.menuHeight = self.MenuConstants.MenuDefaultHeight
            }
            self.addBlurEffectView()
            self.addMenuView()
            self.addTargetedImageView()
            self.openAllViews()
        }
    }
    
    open func changeViewTargeted(newView: UIView, animated: Bool = true){
        DispatchQueue.main.async {
            guard self.viewTargeted != nil else{
                print("targetedView is nil")
                return
            }
            self.viewTargeted.alpha = 1
            if let gesture = self.touchGesture {
                self.viewTargeted.removeGestureRecognizer(gesture)
            }
            self.viewTargeted = newView
            self.targetedImageView.image = self.getRenderedImage(afterScreenUpdates: true)
            if let gesture = self.touchGesture {
                self.viewTargeted.addGestureRecognizer(gesture)
            }
            self.updateTargetedImageViewPosition(animated: animated)
        }
    }
    
    open func updateView(animated: Bool = true){
        DispatchQueue.main.async {
            guard self.viewTargeted != nil else{
                print("targetedView is nil")
                return
            }
            guard self.customView.subviews.contains(self.targetedImageView) else {return}
            if !self.items.isEmpty {
                self.menuHeight = (CGFloat(self.items.count) * self.MenuConstants.ItemDefaultHeight) + (self.headerView?.frame.height ?? 0) + (self.footerView?.frame.height ?? 0) // + CGFloat(self.items.count - 1)
            }else{
                self.menuHeight = self.MenuConstants.MenuDefaultHeight
            }
            self.viewTargeted.alpha = 0
            self.addMenuView()
            self.updateTargetedImageViewPosition(animated: animated)
        }
    }
    
    open func closeMenu(){
        self.closeAllViews()
    }
    
    open func closeMenu(withAnimation animation: Bool) {
        closeAllViews(withAnimation: animation)
    }
    
    // MARK:- Get Rendered Image Functions
    func getRenderedImage(afterScreenUpdates: Bool = false) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: viewTargeted.bounds.size)
        let viewSnapShotImage = renderer.image { ctx in
            viewTargeted.contentScaleFactor = 3
            viewTargeted.drawHierarchy(in: viewTargeted.bounds, afterScreenUpdates: afterScreenUpdates)
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
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        blurEffectView.alpha = 0
        if closeGesture == nil {
            blurEffectView.isUserInteractionEnabled = true
            closeGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewAction(_:)))
            blurEffectView.addGestureRecognizer(closeGesture!)
        }
    }
    
    @objc func dismissViewAction(_ sender: UITapGestureRecognizer? = nil){
        self.closeAllViews()
    }
    
    func addCloseButton(){
        
        if !customView.subviews.contains(closeButton) {
            customView.addSubview(closeButton)
        }
        closeButton.frame = CGRect(x: mainViewRect.origin.x, y: mainViewRect.origin.y, width: mainViewRect.width, height: mainViewRect.height)
        closeButton.setTitle("", for: .normal)
        closeButton.actionHandler(controlEvents: .touchUpInside) { //[weak self] in
            self.closeAllViews()
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
            tableView = UITableView()
        }else{
            tableView.removeFromSuperview()
            tableView = UITableView()
        }
        
        let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
        
        menuView.backgroundColor = MenuConstants.ItemDefaultColor
        menuView.layer.cornerRadius = MenuConstants.MenuCornerRadius
        menuView.clipsToBounds = true
        menuView.frame = CGRect(x: rect.x,
                                y: rect.y,
                                width: self.viewTargeted.frame.width, height: self.viewTargeted.frame.height)
        menuView.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = menuView.bounds
        tableView.register(self.nibView, forCellReuseIdentifier: "ContextMenuCell")
        tableView.tableHeaderView = self.headerView
        tableView.tableFooterView = self.footerView
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = false
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = .clear
        tableView.reloadData()
        
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        tableView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: MenuConstants.MenuWidth).isActive = true
        
//        if let placeHolder = self.placeHolderView {
//            if items.isEmpty {
//                stackView.addArrangedSubview(placeHolder)
//                placeHolder.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
//            }else{
//                placeHolder.removeFromSuperview()
//            }
//        }
            
        
        // MARK:- Previous Item Creation Work
//        items.enumerated().forEach { (index, actionItem) in
//            let btn = UIButton()
//            stackView.addArrangedSubview(btn)
//            btn.setTitle(actionItem.title, for: .normal)
//            btn.setTitleColor(MenuConstants.LabelDefaultColor, for: .normal)
//            btn.titleLabel?.textColor = MenuConstants.LabelDefaultColor
//            if #available(iOS 11.0, *) {
//                btn.contentHorizontalAlignment = .leading
//            }
//            //            btn.font = 14
//            btn.titleLabel?.font = MenuConstants.LabelDefaultFont
//            if let img = actionItem.image {
//                let iconImageView = UIImageView(image: img)
//                iconImageView.tag = 13
//                btn.addSubview(iconImageView)
//                iconImageView.contentMode = .scaleAspectFit
//                iconImageView.translatesAutoresizingMaskIntoConstraints = false
//                iconImageView.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -14).isActive = true
//                iconImageView.heightAnchor.constraint(equalToConstant: 19).isActive = true
//                iconImageView.widthAnchor.constraint(equalToConstant: 19).isActive = true
//                iconImageView.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
//                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 14 + 19 + 12)
//            }else{
//                btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//            }
//            btn.actionHandler(controlEvents: .touchUpInside) { [weak self] in
//                btn.backgroundColor = UIColor.clear
//                if self?.onItemTap?(index, actionItem) ?? false {
//                    self?.closeAllViews()
//                }
//                if let weakSelf = self {
//                    if weakSelf.delegate?.contextMenu(weakSelf, targetedView: (self?.viewTargeted)!, didSelect: actionItem, forRowAt: index) ?? false {
//                        weakSelf.closeAllViews()
//                    }
//                }else{
//                    self?.closeAllViews()
//                }
//            }
//            btn.translatesAutoresizingMaskIntoConstraints = false
//            btn.heightAnchor.constraint(equalToConstant: MenuConstants.ItemDefaultHeight).isActive = true
//            btn.actionHandler(controlEvents: .touchDown) {
//                btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
//            }
//            btn.actionHandler(controlEvents: .touchUpOutside) {
//                btn.backgroundColor = .clear
//            }
//            //            btn.actionHandler(controlEvents: .touchCancel) {
//            //                btn.backgroundColor = .clear
//            //            }
//
//            if (items.count - 1) != index {
//                let lineView = UIView()
//                stackView.addArrangedSubview(lineView)
//                lineView.translatesAutoresizingMaskIntoConstraints = false
//                lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//                lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
//            }
//        }
        
    }
    
    func openAllViews(animated: Bool = true){
        let rect = self.viewTargeted.convert(self.mainViewRect.origin, to: nil)
        viewTargeted.alpha = 0
        //        customView.backgroundColor = .clear
        blurEffectView.alpha = 0
        closeButton.isUserInteractionEnabled = true
        targetedImageView.alpha = 1
        targetedImageView.layer.shadowOpacity = 0.0
        targetedImageView.isUserInteractionEnabled = true
        targetedImageView.frame = CGRect(x: rect.x, y: rect.y, width: self.viewTargeted.frame.width, height: self.viewTargeted.frame.height)
        menuView.alpha = 0
        menuView.isUserInteractionEnabled = true
        //        menuView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
        menuView.frame = CGRect(x: rect.x, y: rect.y, width: self.viewTargeted.frame.width, height: self.viewTargeted.frame.height)
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.blurEffectView.alpha = 1
                self.targetedImageView.layer.shadowOpacity = 0.2
            }
        }else{
            self.blurEffectView.alpha = 1
            self.targetedImageView.layer.shadowOpacity = 0.2
        }
        self.updateTargetedImageViewPosition(animated: animated)
        self.onViewAppear?(self.viewTargeted)
        
        self.delegate?.contextMenuDidAppear(self)
    }
    
    func closeAllViews(){
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        DispatchQueue.main.async {
            //            UIView.animate(withDuration: 0.2, animations: {
            //                self.blurEffectView.alpha = 0
            //                self.targetedImageView.layer.shadowOpacity = 0
            //            }) { (_) in
            //                self.viewTargeted.alpha = 1
            //                self.customView.removeFromSuperview()
            //            }
            self.targetedImageView.isUserInteractionEnabled = false
            self.menuView.isUserInteractionEnabled = false
            self.closeButton.isUserInteractionEnabled = false
            
            let rect = self.viewTargeted.convert(self.mainViewRect.origin, to: nil)
            if self.closeAnimation {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
                    self.prepareViewsForRemoveFromSuperView(with: rect)
                    //                self.menuView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)//.translatedBy(x: 0, y: (self.menuHeight) * CGFloat((rect.y < self.menuView.frame.origin.y) ? -1 : 1) )
                    
                }) { (_) in
                    DispatchQueue.main.async {
                        self.removeAllViewsFromSuperView()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.prepareViewsForRemoveFromSuperView(with: rect)
                    self.removeAllViewsFromSuperView()
                }
            }
            self.onViewDismiss?(self.viewTargeted)
            self.delegate?.contextMenuDidDisappear(self)
        }
    }
    
    func closeAllViews(withAnimation animation: Bool = true) {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        DispatchQueue.main.async {
            self.targetedImageView.isUserInteractionEnabled = false
            self.menuView.isUserInteractionEnabled = false
            self.closeButton.isUserInteractionEnabled = false
            
            let rect = self.viewTargeted.convert(self.mainViewRect.origin, to: nil)
            if animation {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 6, options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
                    self.prepareViewsForRemoveFromSuperView(with: rect)
                }) { (_) in
                    DispatchQueue.main.async {
                        self.removeAllViewsFromSuperView()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.prepareViewsForRemoveFromSuperView(with: rect)
                    self.removeAllViewsFromSuperView()
                }
            }
            self.onViewDismiss?(self.viewTargeted)
            self.delegate?.contextMenuDidDisappear(self)
        }
    }
    
    func prepareViewsForRemoveFromSuperView(with rect: CGPoint) {
        self.blurEffectView.alpha = 0
        self.targetedImageView.layer.shadowOpacity = 0
        self.targetedImageView.frame = CGRect(x: rect.x, y: rect.y, width: self.viewTargeted.frame.width, height: self.viewTargeted.frame.height)
        self.menuView.alpha = 0
        self.menuView.frame = CGRect(x: rect.x, y: rect.y, width: self.viewTargeted.frame.width, height: self.viewTargeted.frame.height)
    }
    
    func removeAllViewsFromSuperView() {
        self.viewTargeted?.alpha = 1
        self.targetedImageView.alpha = 0
        self.targetedImageView.removeFromSuperview()
        self.blurEffectView.removeFromSuperview()
        self.closeButton.removeFromSuperview()
        self.menuView.removeFromSuperview()
        self.tableView.removeFromSuperview()
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape, !isLandscape {
            self.updateView()
            isLandscape = true
            print("Landscape")
        } else if !UIDevice.current.orientation.isLandscape, isLandscape {
            self.updateView()
            isLandscape = false
            print("Portrait")
        }
    }
    
    func getZoomedTargetedSize() -> CGRect{
        
        let rect = viewTargeted.convert(mainViewRect.origin, to: nil)
        let targetedImageFrame = viewTargeted.frame
        
        let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
        let backgroundHeight = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace
        
        var zoomFactor = MenuConstants.MaxZoom
        
//        let zoomFactorHorizontal = backgroundWidth/targetedImageFrame.width
//        let zoomFactorVertical = backgroundHeight/targetedImageFrame.height
//
//        if zoomFactorHorizontal < zoomFactorVertical {
//            zoomFactor = zoomFactorHorizontal
//        }else{
//            zoomFactor = zoomFactorVertical
//        }
//        if zoomFactor > MenuConstants.MaxZoom {
//            zoomFactor = MenuConstants.MaxZoom
//        }
        
        var updatedWidth = targetedImageFrame.width // * zoomFactor
        var updatedHeight = targetedImageFrame.height // * zoomFactor
        
        if backgroundWidth > backgroundHeight {
            
            let zoomFactorHorizontalWithMenu = (backgroundWidth - MenuConstants.MenuWidth - MenuConstants.MenuMarginSpace)/updatedWidth
            let zoomFactorVerticalWithMenu = backgroundHeight/updatedHeight
            
            if zoomFactorHorizontalWithMenu < zoomFactorVerticalWithMenu {
                zoomFactor = zoomFactorHorizontalWithMenu
            }else{
                zoomFactor = zoomFactorVerticalWithMenu
            }
            if zoomFactor > MenuConstants.MaxZoom {
                zoomFactor = MenuConstants.MaxZoom
            }
            
            // Menu Height
            if self.menuHeight > backgroundHeight {
                self.menuHeight = backgroundHeight + MenuConstants.MenuMarginSpace
            }
        }else{
            
            let zoomFactorHorizontalWithMenu = backgroundWidth/(updatedWidth)
            let zoomFactorVerticalWithMenu = backgroundHeight/(updatedHeight + self.menuHeight + MenuConstants.MenuMarginSpace)
            
            if zoomFactorHorizontalWithMenu < zoomFactorVerticalWithMenu {
                zoomFactor = zoomFactorHorizontalWithMenu
            }else{
                zoomFactor = zoomFactorVerticalWithMenu
            }
            if zoomFactor > MenuConstants.MaxZoom {
                zoomFactor = MenuConstants.MaxZoom
            }else if zoomFactor < MenuConstants.MinZoom {
                zoomFactor = MenuConstants.MinZoom
            }
        }

        updatedWidth = (updatedWidth * zoomFactor)
        updatedHeight = (updatedHeight * zoomFactor)
        
        let updatedX = rect.x - (updatedWidth - targetedImageFrame.width)/2
        let updatedY = rect.y - (updatedHeight - targetedImageFrame.height)/2
        
        return CGRect(x: updatedX, y: updatedY, width: updatedWidth, height: updatedHeight)
        
    }
    
    func fixTargetedImageViewExtrudings(){ // here I am checking for extruding part of ImageView
        
//        let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
//        let backgroundHeight = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace
//
//        if backgroundWidth > backgroundHeight {
//
//        }
//        else{
//
//        }
        
        if tvY > mainViewRect.height - MenuConstants.BottomMarginSpace - tvH {
            tvY = mainViewRect.height - MenuConstants.BottomMarginSpace - tvH
        }
        else if tvY < MenuConstants.TopMarginSpace {
            tvY = MenuConstants.TopMarginSpace
        }
        
        if tvX < MenuConstants.HorizontalMarginSpace {
            tvX = MenuConstants.HorizontalMarginSpace
//            mX = MenuConstants.HorizontalMarginSpace
        }
        else if tvX > mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW {
            tvX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW
//            mX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - mW
        }
        
//        if mY
    }
    
    
    
//    func fixHorizontalTargetedImageViewExtruding(){
//
//        let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
//        let backgroundHeight = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace
//
//
//
//    }
    
    func updateHorizontalTargetedImageViewRect(){
        
        let rightClippedSpace = (tvW + MenuConstants.MenuMarginSpace + mW + tvX + MenuConstants.HorizontalMarginSpace) - mainViewRect.width
        let leftClippedSpace = -(tvX - MenuConstants.MenuMarginSpace - mW - MenuConstants.HorizontalMarginSpace)
        
        if leftClippedSpace > 0, rightClippedSpace > 0 {
            
            let diffY = mainViewRect.width - (mW + MenuConstants.MenuMarginSpace + tvW + MenuConstants.HorizontalMarginSpace + MenuConstants.HorizontalMarginSpace)
            if diffY > 0 {
                if (tvX + tvW/2) > mainViewRect.width/2 { //right
                    tvX = tvX + leftClippedSpace
                    mX = tvX - MenuConstants.MenuMarginSpace - mW
                }else{ //left
                    tvX = tvX - rightClippedSpace
                    mX = tvX + MenuConstants.MenuMarginSpace + tvW
                }
            }else{
                if (tvX + tvW/2) > mainViewRect.width/2 { //right
                    tvX = mainViewRect.width - MenuConstants.HorizontalMarginSpace - tvW
                    mX = MenuConstants.HorizontalMarginSpace
                }else{ //left
                    tvX = MenuConstants.HorizontalMarginSpace
                    mX = tvX + tvW + MenuConstants.MenuMarginSpace
                }
            }
        }
        else if rightClippedSpace > 0 {
            mX = tvX - MenuConstants.MenuMarginSpace - mW
        }
        else if leftClippedSpace > 0  {
            mX = tvX + MenuConstants.MenuMarginSpace  + tvW
        }
        else{
            mX = tvX + MenuConstants.MenuMarginSpace + tvW
        }
        
        if mH >= (mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace) {
            mY = MenuConstants.TopMarginSpace
            mH = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace
        }
        else if (tvY + mH) <= (mainViewRect.height - MenuConstants.BottomMarginSpace) {
            mY = tvY
        }
        else if (tvY + mH) > (mainViewRect.height - MenuConstants.BottomMarginSpace){
            mY = tvY - ((tvY + mH) - (mainViewRect.height - MenuConstants.BottomMarginSpace))
        }
        
        
    }
    
    func updateVerticalTargetedImageViewRect(){
        
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
        
    }
    
    func updateTargetedImageViewRect(){
        
        self.mainViewRect = self.customView.frame
        
        let targetedImagePosition = getZoomedTargetedSize()
        
        tvH = targetedImagePosition.height
        tvW = targetedImagePosition.width
        tvY = targetedImagePosition.origin.y
        tvX = targetedImagePosition.origin.x
        mH = menuHeight
        mW = MenuConstants.MenuWidth
        mY = tvY + MenuConstants.MenuMarginSpace
        mX = MenuConstants.HorizontalMarginSpace
        
        self.fixTargetedImageViewExtrudings()
        
//        else{
//            if ((mainViewRect.width/2) - (mX + mW/2))/mainViewRect.width <= 0.5  {
//                mX = mainViewRect.width/2 - mW/2
//            }else{
//                mX = MenuConstants.HorizontalMarginSpace
//            }
//        }
        
        let backgroundWidth = mainViewRect.width - (2 * MenuConstants.HorizontalMarginSpace)
        let backgroundHeight = mainViewRect.height - MenuConstants.TopMarginSpace - MenuConstants.BottomMarginSpace
        
        if backgroundHeight > backgroundWidth {
            self.updateVerticalTargetedImageViewRect()
        }
        else{
            self.updateHorizontalTargetedImageViewRect()
        }
        
        tableView.frame = CGRect(x: 0, y: 0, width: mW, height: mH)
        tableView.layoutIfNeeded()
        
    }
    
    func updateTargetedImageViewPosition(animated: Bool = true){
        
        self.updateTargetedImageViewRect()
        //        menuView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0).translatedBy(x: 0, y: (menuHeight) * CGFloat((tvY < mY) ? -1 : 1) )
        
        if animated {
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 6,
                           options: [.layoutSubviews, .preferredFramesPerSecond60, .allowUserInteraction],
                           animations:
                {  [weak self] in
                    
                    self?.updateTargetedImageViewPositionFrame()
                    
            })
        }else{
            self.updateTargetedImageViewPositionFrame()
        }
    }
    
    func updateTargetedImageViewPositionFrame(){
        let weakSelf = self
        
        weakSelf.menuView.alpha = 1
        //            self.menuView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1) //.translatedBy(x: 0, y: 0)
        weakSelf.menuView.frame = CGRect(
            x: weakSelf.mX,
            y: weakSelf.mY,
            width: weakSelf.mW,
            height: weakSelf.mH
        )
        
        weakSelf.targetedImageView.frame = CGRect(
            x: weakSelf.tvX,
            y: weakSelf.tvY,
            width: weakSelf.tvW,
            height: weakSelf.tvH
        )
        
        weakSelf.blurEffectView.frame = CGRect(
            x: weakSelf.mainViewRect.origin.x,
            y: weakSelf.mainViewRect.origin.y,
            width: weakSelf.mainViewRect.width,
            height: weakSelf.mainViewRect.height
        )
        weakSelf.closeButton.frame = CGRect(
            x: weakSelf.mainViewRect.origin.x,
            y: weakSelf.mainViewRect.origin.y,
            width: weakSelf.mainViewRect.width,
            height: weakSelf.mainViewRect.height
        )
    }
}

extension ContextMenu : UITableViewDataSource, UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextMenuCell", for: indexPath) as! ContextMenuCell
        cell.contextMenu = self
        cell.tableView = tableView
        cell.style = self.MenuConstants
        cell.item = self.items[indexPath.row]
        cell.setup()
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        if self.onItemTap?(indexPath.row, item) ?? false {
            self.closeAllViews()
        }
        if self.delegate?.contextMenuDidSelect(self, cell: tableView.cellForRow(at: indexPath) as! ContextMenuCell, targetedView: self.viewTargeted, didSelect: self.items[indexPath.row], forRowAt: indexPath.row) ?? false {
            self.closeAllViews()
        }
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.delegate?.contextMenuDidDeselect(self, cell: tableView.cellForRow(at: indexPath) as! ContextMenuCell, targetedView: self.viewTargeted, didSelect: self.items[indexPath.row], forRowAt: indexPath.row)
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuConstants.ItemDefaultHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return MenuConstants.ItemDefaultHeight
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
