//
//  ViewController.swift
//  ContextMenuSwiftDemo
//
//  Created by macmin on 01/05/2020.
//  Copyright © 2020 Umer jabbar. All rights reserved.
//

import UIKit
import ContextMenuSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextMenuCell")
        return cell!
    }
    

    @IBOutlet weak var cv1: UIView!
    @IBOutlet weak var cv2: UIView!
    @IBOutlet weak var cv3: UIView!
    
    @IBOutlet weak var canvas: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        let share = ContextMenuItemWithImage(title: "Share", image: #imageLiteral(resourceName: "icons8-upload"))
        let edit = "Edit"
        let delete = ContextMenuItemWithImage(title: "Delete", image: #imageLiteral(resourceName: "icons8-trash"))
//        CM.nibView = UINib(nibName: "CustomCell", bundle: .main)
        CM.items = [share, edit, delete]
        CM.showMenu(viewTargeted: self.cv1, delegate: self)
        let vc1 = UIView(frame: CGRect(x: 0, y: 0, width: CM.MenuConstants.MenuWidth, height: 50))
        vc1.backgroundColor = .purple
        let vc2 = UIView(frame: CGRect(x: 0, y: 0, width: CM.MenuConstants.MenuWidth, height: 10))
        vc2.backgroundColor = .purple
//        CM.headerView = vc1
//        CM.footerView = vc2
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            CM.items = (0..<Int.random(in: 2..<4)).map { "Item \($0)" }
//            CM.changeViewTargeted(newView: self.cv3)
//            CM.updateView()
//        }
        
        
    }
    
}

extension ViewController : ContextMenuDelegate {
    func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {
        return true
    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
        
    }
    
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("contextMenuDidAppear")
    }
    
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("contextMenuDidDisappear")
    }
    
    
    
    
}
