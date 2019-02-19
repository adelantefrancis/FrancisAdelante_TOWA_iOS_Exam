//
//  AssetsView.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

protocol AssetsListViewDataSource: class {
    func assetsListView(numberOfObjects assetsListView: AssetsView) -> Int
    func assetsListView(newsObject assetstListView: AssetsView, objectAt indexPath: IndexPath) -> Asset?
}

protocol AssetsViewControllerDelegate: class {
    func assetsListView(didSelect asset: Asset)
}

class AssetsView: UIView {
    
    
    var assetDatasource: AssetsListViewDataSource?
    var assetDelegate: AssetsViewControllerDelegate?
    
    var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStructure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStructure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupStructure()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

fileprivate extension AssetsView {
    
    func setupStructure() {
        let viewFromNib = viewFromOwnedNib()
        addSubviewAndFill(viewFromNib)
      
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88.0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.register(UINib.init(nibName: "AssetsTableViewCell", bundle: nil), forCellReuseIdentifier: "AssetsTableViewCell")
        addSubview(tableView)
        tableView.bindFrameToSuperviewBounds()
        
        self.layoutIfNeeded()
    }
    
}

extension AssetsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard assetDatasource != nil else {
            return 0
        }
        return assetDatasource!.assetsListView(numberOfObjects: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var assetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AssetsTableViewCell", for: indexPath) as? AssetsTableViewCell
        
        if assetTableViewCell == nil {
            assetTableViewCell = AssetsTableViewCell.fromNib() as? AssetsTableViewCell
        }
        
        assetTableViewCell?.asset = assetDatasource?.assetsListView(newsObject: self, objectAt: indexPath)
        
        return assetTableViewCell!
    }
    
    
}

extension AssetsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assetDelegate?.assetsListView(didSelect: assetDatasource!.assetsListView(newsObject: self, objectAt: indexPath)!)
    }
}
