//
//  ThumbnailCell.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var livePhotoBadgeImageView: UIImageView!
    
    var representedAssetIdentifier: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .lightGray
    }
    
    var thumbnailImage: UIImage! {
        didSet {
            thumbImageView.image = thumbnailImage
        }
    }
    
    var livePhotoBadgeImage: UIImage! {
        didSet {
            livePhotoBadgeImageView.image = livePhotoBadgeImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
        livePhotoBadgeImage = nil
    }
}
