//
//  ViewController.swift
//  ContextMenuSwiftDemo
//
//  Created by macmin on 01/05/2020.
//  Copyright © 2020 Umer jabbar. All rights reserved.
//

import UIKit
import ContextMenuSwift

class ViewController: UIViewController {

    @IBOutlet weak var cv1: UIView!
    @IBOutlet weak var cv2: UIView!
    @IBOutlet weak var cv3: UIView!
    
    @IBOutlet weak var canvas: UIView!
    
    lazy var menu1 : ContextMenu? = cv1.getContextMenu()
    lazy var menu2 : ContextMenu? = cv2.getContextMenu()
    lazy var menu3 : ContextMenu? = cv3.getContextMenu()
    
    lazy var menu4 : ContextMenu? = cv1.getContextMenu()
    lazy var menu5 : ContextMenu? = cv2.getContextMenu()
    lazy var menu6 : ContextMenu? = cv3.getContextMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let window = UIApplication.shared.windows.first else{return}
//        menu1 = ContextMenu(viewTargeted: cv1, window: window)
//        menu1?.addTapInteraction()
//        menu2 = ContextMenu(viewTargeted: cv2, window: window)
//        menu2?.addTapInteraction()
//        menu3 = ContextMenu(viewTargeted: cv3, window: self.canvas)
//        menu3?.addTapInteraction()
        
        example1()
    }
    
    func example1(){
        menu1?.items = (0..<4).map { "Item \($0)" }
        menu1?.addTapInteraction()
        menu2?.items = (0..<11).map { "Item \($0)" }
        menu2?.addTapInteraction()
        menu3?.items = (0..<Int.random(in: 10..<20)).map { "Item \($0)" }
        menu3?.addTapInteraction()
        
//        menu1?.onViewAppear = { _ [weak self] in
////            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                self.menu1?.items = (0..<Int.random(in: 1..<20)).map { "Item \($0)" }
////                self.menu1?.updateView()
////            }
////            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                self.menu1?.changeViewTargeted(newView: self.cv2)
////                self.menu1?.updateView()
////            }
////            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
////                self.menu1?.viewTargeted = self.cv3
////                self.menu1?.updateView()
////            }
////            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
////                self.menu1?.viewTargeted = self.cv1
////                self.menu1?.updateView()
////            }
//        }
//        menu1?.onViewDismiss = { [weak self] (_) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.menu1?.changeViewTargeted(newView: self.cv1)
//            }
//        }
//        menu1?.onItemTap = { [weak self] (index, item) in
//            print(index, item)
//            if item.title == "Item 0" {
//                self.menu1?.items = (0..<Int.random(in: 1..<5)).map { "Item \($0)" }
//                self.menu1?.updateView()
//                return false
//            }
//            return true
//        }
    }
    
    func example2(){
        menu4?.items = (0..<Int.random(in: 1..<5)).map { "Item \($0)" }
        menu4?.addTapInteraction()
        menu5?.items = (0..<Int.random(in: 5..<10)).map { "Item \($0)" }
        menu5?.addTapInteraction()
        menu6?.items = (0..<Int.random(in: 10..<20)).map { "Item \($0)" }
        menu6?.addTapInteraction()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
//        cv1.showMenu(items: (0..<Int.random(in: 5..<10)).map { "Item \($0)" }) { (index, item) in
//            print(index, item)
//            return true
//        }
//        menu1?.items = (0..<Int.random(in: 5..<10)).map { "Item \($0)" }
//        menu1?.showMenu()
        
        let menu = ContextMenu(viewTargeted: self.cv1)
        menu?.items = (0..<Int.random(in: 0..<20)).map { "Item \($0)" }
        menu?.showMenu()
//        menu?.onViewDismiss = { _ in
//
//        }
    }
    
}

