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
        
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        CM.items = (0..<Int.random(in: 6..<8)).map { "Item \($0)" }
        CM.showMenu(viewTargeted: self.cv1, delegate: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            CM.items = (0..<Int.random(in: 2..<4)).map { "Item \($0)" }
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
