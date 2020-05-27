//
//  SIngleSeriesCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct SingleSeriesCellViewModel {
    let state: State<Media>
}

final class SingleSeriesCell: UICollectionViewCell {
    static let itemWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var eposodeName: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverPhoto.layer.cornerRadius = 4.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverPhoto.image = UIImage(named: "placeholder")
    }

}

extension SingleSeriesCell: CellConfigurable {
    typealias ModelType = SingleSeriesCellViewModel
    
    func configure(model: SingleSeriesCellViewModel) {
        if case let .loaded(episode) = model.state {
            loadingView.isHidden = true
            sendSubviewToBack(loadingView)
            if let url = episode.coverUrl {
                coverPhoto.loadImage(url, placeHolder: nil)
            }
            eposodeName.text = episode.title
            
        } else {
            bringSubviewToFront(loadingView)
            loadingView.isHidden = false
        }
        
    }
}
