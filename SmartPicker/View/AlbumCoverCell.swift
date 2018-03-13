//
//  AlbumCoverCell.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit
import Photos

protocol AlbumCoverCellDelegate: class {
    func tapped()
}

class AlbumCoverCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView! {
        didSet {
            albumImageView.isUserInteractionEnabled = true
            albumImageView.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    weak var delegate: AlbumCoverCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        albumImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        delegate?.tapped()
    }
    
    func configure(viewModel: AlbumCoverViewModel) {
        albumTitleLabel.text = viewModel.titleForCover ?? ""
        albumImageView.image = viewModel.imageCover ?? #imageLiteral(resourceName: "placeholder")
    }
}

// MARK: View Model
struct AlbumCoverViewModel {
    
    private let imageCoverAsset: PHAsset?
    private let title: String?
    fileprivate let imageManager = PHCachingImageManager()
    private var thumbSize: CGSize

    
    init(cover: PHAsset?, title: String?, size: CGSize) {
        self.imageCoverAsset = cover
        self.title = title
        self.thumbSize = size
    }
    
    var titleForCover: String? {
        return self.title
    }
    
    var imageCover: UIImage? {
        var localImage: UIImage?
        let scale: CGFloat = UIScreen.main.scale
        let targetSize = CGSize(width: thumbSize.width * scale, height: thumbSize.height * scale)
        guard let coverAsset = self.imageCoverAsset else { return nil }
        imageManager.requestImage(for: coverAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
            if let im = image {
                localImage = im
            }
        }
        return localImage
    }
}








