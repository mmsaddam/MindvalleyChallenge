//
//  ChannelCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct ChannelCourseDesignCellViewModel {
    
    let channel: Channel
    
    func getMaxHeight() -> CGFloat? {
        channel.latestMedia.map { getTextHeight(for: $0) }.max()
    }
    
    func getTextHeight(for media: Media) -> CGFloat {
        var totalHeight: CGFloat = 0
        let titleFont = UIFont(name: "Roboto-Regular", size: 17)!
        let titleHeight = media.title.getHeight(for: SingleCourseCell.itemWidth , font: titleFont)
        totalHeight += titleHeight
        
        return totalHeight
    }
    
    var mediaList: [Media] {
        channel.latestMedia
    }
    
    var iconUrl: URL? {
        channel.iconUrl
    }
    var title: String? {
        channel.title
    }
    var episodes: String? {
        "\(channel.mediaCount ?? 0)  episodes"
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
            collectionView.dataSource = self
        }
    }
    
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
        let height = collectionView.bounds.height
        layout.itemSize = CGSize(width: SingleCourseCell.itemWidth, height: height)
        collectionView.collectionViewLayout = layout
        self.layout = layout
    }
    
    private func updateItemSize() {
        let height = collectionView.bounds.height
        layout?.itemSize.height = height
        layout?.invalidateLayout()
    }
    
}

// MARK: - CellConfigurable
extension ChannelCourseDesignCell: CellConfigurable {
    typealias ModelType = ChannelCourseDesignCellViewModel

    func configure(model: ChannelCourseDesignCellViewModel) {
        self.viewModel = model
        if let url = model.iconUrl {
            channelImage.loadImage(url)
        }
        
        channelTitle.text = model.title
        countLabel.text = model.episodes
        updateItemSize()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ChannelCourseDesignCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.mediaList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleCourseCell",
                                                      for: indexPath) as! SingleCourseCell
        if let media = viewModel?.mediaList[indexPath.row] {
            let viewModel = SingleCourseCellViewModel(media: media)
            cell.configure(model: viewModel)
        }
        
        return cell
    }
    
}
