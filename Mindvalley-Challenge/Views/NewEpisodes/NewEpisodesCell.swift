//
//  NewEpisodesCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit



final class NewEpisodesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            let nib = UINib(nibName: "SingleEpisodeCell", bundle: Bundle(for: SingleEpisodeCell.self))
            collectionView.register(nib, forCellWithReuseIdentifier:
                "SingleEpisodeCell")
            collectionView.dataSource = self
        }
    }
    
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
    
    private func updateItemSize() {
        layout?.itemSize.height = collectionView.bounds.height
        layout?.invalidateLayout()
    }

}

// MARK: - CellConfigurable
extension NewEpisodesCell: CellConfigurable {
    typealias ModelType = NewEpisodesCellViewModel
    
    func configure(model: NewEpisodesCellViewModel) {
        self.viewModel = model
        updateItemSize()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension NewEpisodesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.episodes.count ?? 0
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleEpisodeCell",
                                                      for: indexPath) as! SingleEpisodeCell
        if let media = viewModel?.episodes[indexPath.row] {
            let viewModel = SingleEpisodeCellViewModel(media: media)
            cell.configure(model: viewModel)
        }
        return cell
    }
    
}
