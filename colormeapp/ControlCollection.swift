//
//  ControlCollection.swift
//  colormeapp
//
//  Created by Max Nelson on 5/22/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit

class ControlCollection: UICollectionView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate var layout:UICollectionViewFlowLayout = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        cl.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        cl.minimumLineSpacing = 16
        cl.minimumInteritemSpacing = 16
        return cl
    }()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        initPhaseTwo()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initPhaseTwo()
    }
    
    func initPhaseTwo() {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.MNGray.cgColor
        self.register(ControlCell.self, forCellWithReuseIdentifier: "control")
        self.register(AdjustControlCell.self, forCellWithReuseIdentifier: "adjustcontrol")
        self.register(FilterPackControlCell.self, forCellWithReuseIdentifier: "filterpackcontrol")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white.withAlphaComponent(0.4)
    }
}
