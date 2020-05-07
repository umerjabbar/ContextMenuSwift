//
//  ViewController.swift
//  ContextMenuSwiftDemo
//
//  Created by macmin on 01/05/2020.
//  Copyright © 2020 Umer jabbar. All rights reserved.
//

import UIKit
import ContextMenuSwift

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var cv1: UIView!
    @IBOutlet weak var cv2: UIView!
    @IBOutlet weak var cv3: UIView!
    
    @IBOutlet weak var canvas: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let window = UIApplication.shared.windows.first else{return}
//        menu1 = ContextMenu(viewTargeted: cv1, window: window)
//        menu1?.addTapInteraction()
//        menu2 = ContextMenu(viewTargeted: cv2, window: window)
//        menu2?.addTapInteraction()
//        menu3 = ContextMenu(viewTargeted: cv3, window: self.canvas)
//        menu3?.addTapInteraction()
        
//        example1()
        
        
    }
    
    deinit {
        
    }
    
    func example1(){
        CM.items = (0..<Int.random(in: 10..<20)).map { "Item \($0)" }
        CM.showMenu(viewTargeted: self.cv1, delegate: self)
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        CM.items = (0..<Int.random(in: 10..<20)).map { "Item \($0)" }
        CM.showMenu(viewTargeted: self.cv1, delegate: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            CM.changeViewTargeted(newView: self.cv3)
            CM.updateView()
        }
    }
    
}

extension ViewController : ContextMenuDelegate {
    
    func contextMenu(_ contextMenu: ContextMenu, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
        print(item.title)
        return true
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
    }
    
    
    
    
}
