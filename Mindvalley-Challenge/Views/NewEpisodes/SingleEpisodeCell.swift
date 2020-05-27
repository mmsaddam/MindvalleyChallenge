//
//  SingleEpisodeCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 28/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct SingleEpisodeCellViewModel {
    let media: Media
}


final class SingleEpisodeCell: UICollectionViewCell {
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

extension SingleEpisodeCell: CellConfigurable {
    typealias ModelType = SingleEpisodeCellViewModel
    
    func configure(model: SingleEpisodeCellViewModel) {
        if let url = model.media.coverUrl {
            coverPhoto.loadImage(url)
        }
        eposodeName.text = model.media.title
        channelName.text = model.media.channelTitle
    }
}
