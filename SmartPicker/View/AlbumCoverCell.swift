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
    }
}

// MARK: View Model
struct AlbumCoverViewModel {
    
    private let imageCover: PHAsset?
    private let title: String?
    
    init(cover: PHAsset?, title: String?) {
        self.imageCover = cover
        self.title = title
    }
    
    var titleForCover: String? {
        return self.title
    }
}
