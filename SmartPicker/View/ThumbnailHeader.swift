//
//  ThumbnailHeader.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailHeader: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    var representedAssetIdentifier: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var headerImage: UIImage! {
        didSet {
            imageView.image = headerImage
        }
    }
    
    var headerTitle: String! {
        didSet {
            themeLabel.text = headerTitle
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerImage = nil
        headerTitle = nil
    }
}






