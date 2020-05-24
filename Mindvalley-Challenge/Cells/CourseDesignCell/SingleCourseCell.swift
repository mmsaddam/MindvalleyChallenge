//
//  SingleCourseCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct SingleCourseCellViewModel {
    let state: State<Media>
}

final class SingleCourseCell: UICollectionViewCell {
    static let itemWidth: CGFloat = 152.0
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var eposodeName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverPhoto.layer.cornerRadius = 4.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverPhoto.image = nil
    }

}

extension SingleCourseCell: CellConfigurable {
    typealias ModelType = SingleCourseCellViewModel
    
    func configure(model: SingleCourseCellViewModel) {
        if case let .loaded(episode) = model.state {
            loadingView.isHidden = true
            sendSubviewToBack(loadingView)
            if let url = episode.coverUrl {
                coverPhoto.loadImage(url, placeHolder: nil)
            }
            eposodeName.text = episode.title
            channelName.text = episode.channelTitle
        } else {
            bringSubviewToFront(loadingView)
            loadingView.isHidden = false
        }
    }
}
