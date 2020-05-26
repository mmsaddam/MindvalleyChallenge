//
//  ChannelCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct ChannelCourseDesignCellViewModel {
    
    let state: State<Channel>
    
    func getMaxHeight() -> CGFloat? {
        if case let .loaded(channel) = state {
            return channel.latestMedia.map { getTextHeight(for: $0) }.max()
        }
        return nil
    }
    
    func getTextHeight(for media: Media) -> CGFloat {
        var totalHeight: CGFloat = 0
        let titleFont = UIFont(name: "Roboto-Regular", size: 17)!
        let titleHeight = media.title.getHeight(for: SingleCourseCell.itemWidth , font: titleFont)
        totalHeight += titleHeight
        
        return totalHeight
    }
    
    var mediaList: [Media] {
        if case let .loaded(channel) = state {
            return channel.latestMedia
        }
        return []
    }
    
    var iconUrl: URL? {
        if case let .loaded(channel) = state {
            return channel.iconUrl
        }
        return nil
    }
    var title: String? {
        if case let .loaded(channel) = state {
            return channel.title
        }
        return nil
    }
    var episodes: String? {
        if case let .loaded(channel) = state {
            return "\(channel.mediaCount ?? 0)  episodes"
        }
        return nil
    }
    
}


final class ChannelCourseDesignCell: UITableViewCell {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let nib = UINib(nibName: "SingleCourseCell", bundle: Bundle(for: SingleCourseCell.self))
            collectionView.register(nib, forCellWithReuseIdentifier:
                "SingleCourseCell")
            let seriesNib = UINib(nibName: "SingleSeriesCell", bundle: Bundle(for: SingleSeriesCell.self))
                       collectionView.register(seriesNib, forCellWithReuseIdentifier:
                           "SingleSeriesCell")
                      
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var collectionHeightConstraints: NSLayoutConstraint!
    
    private var loadingCount = 5
    private var viewModel: ChannelCourseDesignCellViewModel?
    private var layout: HorizontalFlowLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        channelImage.layer.cornerRadius = 25.0
    }
    
    private func configureLayout() {
        let layout = HorizontalFlowLayout()
        layout.itemSize = CGSize(width: SingleCourseCell.itemWidth, height: 380)
        collectionView.collectionViewLayout = layout
        self.layout = layout
    }
    
    private func updateCollectionHeight(_ height: CGFloat) {
        layout?.itemSize.height = height
        layout?.invalidateLayout()
        collectionHeightConstraints.constant = height
        setNeedsUpdateConstraints()
    }

}

// MARK: - CellConfigurable
extension ChannelCourseDesignCell: CellConfigurable {
    typealias ModelType = ChannelCourseDesignCellViewModel

    func configure(model: ChannelCourseDesignCellViewModel) {
        self.viewModel = model
        if let height = model.getMaxHeight() {
            let coverPhotoHeight: CGFloat = 228.0
            let itemItemVertialSpacing: CGFloat = 10
            let collectionViewHeight = coverPhotoHeight + itemItemVertialSpacing + height
            updateCollectionHeight(collectionViewHeight)
        }
        
        if let url = model.iconUrl {
          channelImage.loadImage(url, placeHolder: nil)
        }
        
        channelTitle.text = model.title
        countLabel.text = model.episodes
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ChannelCourseDesignCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if case .loading = viewModel?.state {
            return loadingCount
        }
        return viewModel?.mediaList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleCourseCell",
                                                      for: indexPath) as! SingleCourseCell
        if let vm = viewModel {
            let state = vm.state
            
            if case .loading = state {
                
                let viewModel = SingleCourseCellViewModel(state: .loading, cellType: .channel)
                cell.configure(model: viewModel)
            } else {
                let media = vm.mediaList[indexPath.row]
                let viewModel = SingleCourseCellViewModel(state: .loaded(media), cellType: .channel)
                cell.configure(model: viewModel)
            }
        }
        return cell
    }
    
}
