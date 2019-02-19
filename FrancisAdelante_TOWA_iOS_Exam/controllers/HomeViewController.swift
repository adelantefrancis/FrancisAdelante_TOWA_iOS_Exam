//
//  HomeViewController.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var homeSegmentedControl: UISegmentedControl!
    @IBOutlet var homeContentView: UIView!
    
    let assetsView = AssetsView()
    let spacesView = SpacesView()
    let suppliersView = SuppliersView()
    let assetDataAdapter = AssetsDataAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeContentView.addSubviewAndFill(assetsView)
        homeContentView.addSubviewAndFill(spacesView)
        homeContentView.addSubviewAndFill(suppliersView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        assetsView.isHidden = false
        spacesView.isHidden = true
        suppliersView.isHidden = true
        assetsView.assetDatasource = assetDataAdapter
        assetsView.assetDelegate = self
        ApiManager.shared.assets.fetchAssets { (response) in
            DispatchQueue.main.async {
               self.assetsView.reloadData()
            }
        }
        
    }
    
    @IBAction func tappedSegmentedControl(_ sender: Any) {
        
        if let segment = sender as? UISegmentedControl {
            switch segment.selectedSegmentIndex {
            case 0 :
                assetsView.isHidden = false
                spacesView.isHidden = true
                suppliersView.isHidden = true
            case 1 :
                assetsView.isHidden = true
                spacesView.isHidden = false
                suppliersView.isHidden = true
            case 2:
                assetsView.isHidden = true
                spacesView.isHidden = true
                suppliersView.isHidden = false
            default :
                assetsView.isHidden = false
                spacesView.isHidden = true
                suppliersView.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AssetsViewController
        vc?.asset = sender as? Asset
    }
}

extension HomeViewController: AssetsViewControllerDelegate {
    func assetsListView(didSelect asset: Asset) {
        performSegue(withIdentifier: "push.AssetsViewController", sender: asset)
    }
    
    
}
