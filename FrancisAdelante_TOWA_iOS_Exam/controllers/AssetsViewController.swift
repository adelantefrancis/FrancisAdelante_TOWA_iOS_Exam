//
//  AssetsViewController.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class AssetsViewController: UIViewController {
  
    @IBOutlet var noteslabel: UILabel!
    @IBOutlet var floor: UILabel!
    @IBOutlet var isInactive: UILabel!
    @IBOutlet var assetClass: UILabel!
    @IBOutlet var assetSubClass: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var assetPhoto: UIImageView!
    
    var asset:Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            noteslabel.text = asset?.assetNote
            floor.text = asset?.assetFloor
        if asset?.assetIsInactive ?? false {
            isInactive.text = "true"
        } else {
            isInactive.text = "false"
        }
            assetClass.text = asset?.assetClass
            assetSubClass.text = asset?.assetSubClass
            type.text = asset?.assetType
        
        assetPhoto.loadImg(url: URL(string: asset!.assetImg!)!, placeholder: nil)
    }
    
}
