//
//  SingleCourseCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct SingleCourseCellViewModel {
    enum CellType {
        case channel
        case episode
    }
    let state: State<Media>
    let cellType: CellType 
}

final class SingleCourseCell: UICollectionViewCell {
    static let itemWidth: CGFloat = 152.0
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var eposodeName: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var noChannelNameConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var episodeNameBottomConstraints: NSLayoutConstraint!
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
        let channelNameConstraints = channelName.constraints
        if model.cellType == .channel {
            channelName.isHidden = true
            NSLayoutConstraint.deactivate(channelNameConstraints)
            noChannelNameConstraints.isActive = true
            episodeNameBottomConstraints.isActive = false
        } else {
            channelName.isHidden = false
            NSLayoutConstraint.activate(channelNameConstraints)
            episodeNameBottomConstraints.isActive = true
            noChannelNameConstraints.isActive = false
        }
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
        setNeedsUpdateConstraints()
    }
}
