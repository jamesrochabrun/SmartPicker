//
//  Nibable.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Nibable {}

extension Nibable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UIView: Nibable {}

extension UIView {
    
    func instantiateNib<T: UIView>(_ :T.Type, in bundle: Bundle? = nil, owner: Any?, options: [AnyHashable : Any]? = nil) {
        UINib(nibName: T.nibName, bundle: bundle).instantiate(withOwner: owner, options: options)
    }
    
    func instanceFromNib<T: UIView>(_ :T.Type, in bundle: Bundle? = nil, owner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T {
        return UINib(nibName: T.nibName, bundle: bundle).instantiate(withOwner: owner, options: options)[0] as! T
    }
    
    static func nib<T: UIView>(_ :T.Type, in bundle: Bundle? = nil, owner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T {
        return UINib(nibName: T.nibName, bundle: bundle).instantiate(withOwner: owner, options: options)[0] as! T
    }
}

extension UIViewController: Nibable {}

extension Nibable where Self: UIViewController {
    static var name: String {
        return String(describing: self)
    }
}

extension UIViewController {
    
    static func nib<T: UIViewController>(_ :T.Type, in bundle: Bundle? = nil) -> T {
        return T(nibName: T.name, bundle: bundle) 
    }
}










