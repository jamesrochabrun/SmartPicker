//
//  Reusable.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocol
protocol Reusable {}

//MARK: protocol extension constrained to UITableViewCell
extension Reusable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: protocol extension constrained to UICollectionViewCell
extension Reusable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: elements conforming to Reusable
extension UICollectionViewCell: Reusable {}
extension UITableViewCell: Reusable {}

//MARK: extending Collections
extension UITableView {
    
    typealias DataSourceCompletionHandler = () -> ()
    func registerDataSource<T: UITableViewDataSource>(_ _dataSource: T, completion: @escaping DataSourceCompletionHandler) {
        dataSource = _dataSource
        completion()
    }
    
    func register<T: UITableViewCell>(_ :T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("could not dequeue cell")
        }
        return cell
    }
    
    func registerNib<T: UITableViewCell>(_ :T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("could not dequeue cell")
        }
        return cell
    }
}

extension UICollectionView {
    
    typealias DataSourceCompletionHandler = () -> ()
    func registerDataSource<T: UICollectionViewDataSource>(_ _dataSource: T, completion: @escaping DataSourceCompletionHandler) {
        dataSource = _dataSource
        completion()
    }
    
    func register<T: UICollectionViewCell>(_ :T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNib<T: UICollectionViewCell>(_ :T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("could not dequeue cell")
        }
        return cell
    }
    
    func registerHeader<T: UICollectionViewCell>(_ :T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNibHeader<T: UICollectionViewCell>(_ : T.Type, in bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueSuplementaryView<T: UICollectionViewCell>(of kind: String, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("could not dequeue cell")
        }
        return cell
    }
    
    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        return cellForItem(at: indexPath) as! T
    }
}







