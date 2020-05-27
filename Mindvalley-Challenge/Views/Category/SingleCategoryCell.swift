//
//  SingleCategoryCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 27/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct SingleCategoryCellViewModel {
    let category: Category
    
    var title: String? {
        return category.name
    }
}

final class SingleCategoryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 30.0
    }
    
}

extension SingleCategoryCell: CellConfigurable {
    typealias ModelType = SingleCategoryCellViewModel
    
    func configure(model: SingleCategoryCellViewModel) {
        titleLabel.text = model.title
    }
}
