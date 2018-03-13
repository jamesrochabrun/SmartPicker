//
//  MainVC.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit


class MainVC: UIViewController {
    @IBOutlet weak var menuScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    func setUpControllers() {
        
        let v1 = MomentsVC.nib(MomentsVC.self)
        self.addChildViewController(v1)
        self.menuScrollView.addSubview(v1.view)
        v1.didMove(toParentViewController: self)
        
        let v2 = AlbumsVC.nib(AlbumsVC.self)
        self.addChildViewController(v2)
        self.menuScrollView.addSubview(v2.view)
        v2.didMove(toParentViewController: self)
        
        var v2Frame = v2.view.frame
        v2Frame.origin.x = self.view.frame.width
        v2.view.frame = v2Frame
        
        let v3 = PlacesVC.nib(PlacesVC.self)
        self.addChildViewController(v3)
        self.menuScrollView.addSubview(v3.view)
        v3.didMove(toParentViewController: self)
        
        var v3Frame = v3.view.frame
        v3Frame.origin.x = self.view.frame.width * 2
        v3.view.frame = v3Frame
        
        self.menuScrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.size.height)
    }
}




