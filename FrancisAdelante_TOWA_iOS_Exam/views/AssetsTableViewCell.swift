//
//  AssetsTableViewCell.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/15/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import TagListView

class AssetsTableViewCell: UITableViewCell {

    
    
    @IBOutlet var assetCellImage: UIImageView!
    @IBOutlet var assetTag: TagListView!
    @IBOutlet var assetLabel: UILabel!
    @IBOutlet var assetNotes: UILabel!
    
    var asset: Asset? {
        didSet {
            assetLabel.text = asset?.assetLabel
            assetNotes.text = asset?.assetNote
            assetTag.removeAllTags()
            assetTag.addTag(asset?.assetType ?? "")
            assetTag.addTag(asset?.assetSubClass ?? "")
            assetTag.addTag(asset?.assetClass ?? "")
            if let photoURL = asset?.assetImg {
                assetCellImage?.loadImg(url: URL(string: photoURL)!, placeholder: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
