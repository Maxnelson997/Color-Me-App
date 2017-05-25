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
        cl.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        cl.minimumLineSpacing = 15
        cl.minimumInteritemSpacing = 5
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
