//
//  AlbumSectionHeader.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

class AlbumSectionHeader: UICollectionViewCell {
    @IBOutlet weak var sectionTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(viewModel: AlbumSectionHeaderViewModel) {
        sectionTitle.text = viewModel.titleForSection ?? ""
    }
}

// MARK: View Model
struct AlbumSectionHeaderViewModel {
    
    private let title: String?
    
    init(title: String?) {
        self.title = title
    }
    
    var titleForSection: String? {
        return self.title
    }
}
