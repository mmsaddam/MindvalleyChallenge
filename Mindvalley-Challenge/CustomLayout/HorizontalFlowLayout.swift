//
//  HorizontalFlowLayout.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

final class HorizontalFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commontInit()
    }
    
    private func commontInit() {
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 20
    }
}
