//
//  CollectionView-Extension.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/11/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}
