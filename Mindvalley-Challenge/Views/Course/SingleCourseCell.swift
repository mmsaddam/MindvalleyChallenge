//
//  SingleCourseCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct SingleCourseCellViewModel {
    let media: Media
}

final class SingleCourseCell: UICollectionViewCell {
    static let itemWidth: CGFloat = 152.0
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var eposodeName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverPhoto.layer.cornerRadius = 4.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverPhoto.image = UIImage(named: "placeholder")
    }
    
}

extension SingleCourseCell: CellConfigurable {
    typealias ModelType = SingleCourseCellViewModel
    
    func configure(model: SingleCourseCellViewModel) {
        if let url = model.media.coverUrl {
            coverPhoto.loadImage(url)
        }
        eposodeName.text = model.media.title
        channelName.text = model.media.channelTitle
        setNeedsUpdateConstraints()
    }
}
