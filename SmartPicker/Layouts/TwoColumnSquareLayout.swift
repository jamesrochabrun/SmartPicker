//
//  TwoColumnSquareLayout.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.

import Foundation
import UIKit

class TwoColumnSquareLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 0.5
    let numberOfItemsInRow: CGFloat = 2
    
    override init() {
        super.init()
        minimumLineSpacing = innerSpace
        minimumInteritemSpacing = innerSpace
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func itemWidth() -> CGFloat {
        return ((self.collectionView?.frame.size.width)! / self.numberOfItemsInRow) - self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
        }
        get {
            return CGSize(width: itemWidth(), height: itemWidth())
        }
    }
}
