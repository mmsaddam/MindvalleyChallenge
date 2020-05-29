//
//  TableViewSeriesCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 26/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct TableViewSeriesCellViewModel {
    
    let channel: Channel
    
    func getTextHeight(for media: Media) -> CGFloat {
        var totalHeight: CGFloat = 0
        let titleFont = UIFont(name: "Roboto-Regular", size: 17)!
        let titleHeight = media.title.getHeight(for: SingleSeriesCell.itemWidth , font: titleFont)
        totalHeight += titleHeight
        
        return totalHeight
    }
    
    func itemMaxHeight() -> CGFloat {
        let photoHeight: CGFloat = 172.0
        let spacing: CGFloat = 10.0
        let textHeight = channel.series.map { getTextHeight(for: $0) }.max() ?? 22
        return photoHeight + spacing + textHeight
    }
    
    var mediaList: [Media] {
        channel.series
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


class TableViewSeriesCell: UITableViewCell {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let seriesNib = UINib(nibName: "SingleSeriesCell", bundle: Bundle(for: SingleSeriesCell.self))
                       collectionView.register(seriesNib, forCellWithReuseIdentifier:
                        SingleSeriesCell.reuseID())
                      
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var loadingCount = 5
    private var viewModel: TableViewSeriesCellViewModel?
    private var layout: HorizontalFlowLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        channelImage.layer.cornerRadius = 25.0
    }
    
    private func configureLayout() {
        let layout = HorizontalFlowLayout()
        layout.itemSize = CGSize(width: SingleSeriesCell.itemWidth, height: collectionView.bounds.height)
        collectionView.collectionViewLayout = layout
        self.layout = layout
    }
    
    private func updateCollectionHeight(_ height: CGFloat) {
        collectionViewHeight.constant = height
        layout?.itemSize.height = height
        layout?.invalidateLayout()
        setNeedsUpdateConstraints()
    }

}

// MARK: - CellConfigurable
extension TableViewSeriesCell: CellConfigurable {
    typealias ModelType = TableViewSeriesCellViewModel

    func configure(model: TableViewSeriesCellViewModel) {
        self.viewModel = model
        updateCollectionHeight(model.itemMaxHeight())
        if let url = model.iconUrl {
            channelImage.loadImage(url)
        }
        
        channelTitle.text = model.title
        countLabel.text = model.episodes
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TableViewSeriesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.mediaList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleSeriesCell.reuseID(),
                                                      for: indexPath) as! SingleSeriesCell
        if let media = viewModel?.mediaList[indexPath.row] {
            let viewModel = SingleSeriesCellViewModel(media: media)
            cell.configure(model: viewModel)
        }
        
        return cell
    }
    
}
