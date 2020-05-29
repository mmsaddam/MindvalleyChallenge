//
//  NewEpisodesCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct NewEpisodesCellViewModel {
    let state: State<[Media]>
    
    public var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    public var episodes: [Media]? {
        if case let .loaded(episodes) = state {
            return episodes
        }
        return nil
    }
    
    public func numberOfItems() -> Int {
        if isLoading {
            return 5
        } else {
            return episodes?.count ?? 0
        }
    }
    
    private func getMaxHeight() -> CGFloat {
        let detaultHeight: CGFloat = 32 + 44 // Default title and channel name height
        guard let episodes = episodes else { return detaultHeight }
        return episodes.map { getTextHeight(for: $0) }.max() ?? detaultHeight
    }
     
     private func getTextHeight(for media: Media) -> CGFloat {
         let width = SingleEpisodeCell.itemWidth
         var totalHeight: CGFloat = 0
         let titleFont = UIFont(name: "Roboto-Regular", size: 17)!
         let titleHeight = media.title.getHeight(for: width , font: titleFont)
         totalHeight += titleHeight
         if let channelTitle = media.channelTitle {
             let channelFont = UIFont(name: "Roboto-Regular", size: 13)!
             let channelHeight = channelTitle.getHeight(for: width, font: channelFont)
             totalHeight += channelHeight
         }
         return totalHeight
         
     }
     
    func itemMaxHeight() -> CGFloat {
         let topMargin: CGFloat = 8
         let bottomMargin: CGFloat = 8
         let coverPhotoHeight: CGFloat = 228
         let internItemVertialSpacing: CGFloat = 10 + 12
         let itemTextHeight = getMaxHeight()
         return topMargin + bottomMargin + coverPhotoHeight + internItemVertialSpacing + itemTextHeight
     }
}


final class NewEpisodesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let nib = UINib(nibName: "SingleEpisodeCell", bundle: Bundle(for: SingleEpisodeCell.self))
            collectionView.register(nib, forCellWithReuseIdentifier:
                SingleEpisodeCell.reuseID())
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var loadingCount = 5
    private var viewModel: NewEpisodesCellViewModel?
    private var layout: HorizontalFlowLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        let layout = HorizontalFlowLayout()
        let height = collectionView.bounds.height
        layout.itemSize = CGSize(width: SingleCourseCell.itemWidth, height: height)
        collectionView.collectionViewLayout = layout
        self.layout = layout
    }
    
    private func updateItemSize(_ height: CGFloat) {
        collectionViewHeight.constant = height
        layout?.itemSize.height = height
        layout?.invalidateLayout()
        setNeedsUpdateConstraints()
    }

}

// MARK: - CellConfigurable
extension NewEpisodesCell: CellConfigurable {
    typealias ModelType = NewEpisodesCellViewModel
    
    func configure(model: NewEpisodesCellViewModel) {
        self.viewModel = model
        updateItemSize(model.itemMaxHeight())
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension NewEpisodesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleEpisodeCell.reuseID(),
                                                      for: indexPath) as! SingleEpisodeCell
        if viewModel?.isLoading == true {
            let viewModel = SingleEpisodeCellViewModel(state: .loading)
            cell.configure(model: viewModel)
        } else if let media = viewModel?.episodes?[indexPath.row] {
            let viewModel = SingleEpisodeCellViewModel(state: .loaded(media))
            cell.configure(model: viewModel)
        }
        return cell
    }
    
}
