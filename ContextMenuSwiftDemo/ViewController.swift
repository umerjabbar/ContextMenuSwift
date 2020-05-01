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
    
    var menu1 : ContextMenu?
    var menu2 : ContextMenu?
    var menu3 : ContextMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let window = UIApplication.shared.windows.first else{return}
        menu1 = ContextMenu(viewTargeted: cv1, window: window)
//        menu1?.addTapInteraction()
        menu2 = ContextMenu(viewTargeted: cv2, window: window)
        menu2?.addTapInteraction()
        
        menu3 = ContextMenu(viewTargeted: cv3, window: self.canvas)
        menu3?.addTapInteraction()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        cv1.showMenu(items: ["a", "b"]) { (index, item) in
            print(index, item)
        }
        
        menu1?.showMenu()
    }
    
}

