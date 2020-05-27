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
            let nib = UINib(nibName: "SingleCourseCell", bundle: Bundle(for: SingleCourseCell.self))
            collectionView.register(nib, forCellWithReuseIdentifier:
                "SingleCourseCell")
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var collectionHeightConstraints: NSLayoutConstraint!
    
    private var loadingCount = 5
    private var viewModel: NewEpisodesCellViewModel?
    private var layout: HorizontalFlowLayout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
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
extension NewEpisodesCell: CellConfigurable {
    typealias ModelType = NewEpisodesCellViewModel

    func configure(model: NewEpisodesCellViewModel) {
        self.viewModel = model
        if let height = model.getMaxHeight() {
            let coverPhotoHeight: CGFloat = 228
            let itemItemVertialSpacing: CGFloat = 10 + 12
            let collectionViewHeight = coverPhotoHeight + itemItemVertialSpacing + height
            updateCollectionHeight(collectionViewHeight)
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension NewEpisodesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let state = viewModel?.state, case let .loaded(episodes) = state {
            return episodes.count
        }
        return loadingCount
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleCourseCell",
                                                      for: indexPath) as! SingleCourseCell
        if let vm = viewModel {
            let state = vm.state
            
            if case let .loaded(episodes) = state {
                let episode = episodes[indexPath.row]
                let viewModel = SingleCourseCellViewModel(state: .loaded(episode), cellType: .episode)
                cell.configure(model: viewModel)
            } else {
                let viewModel = SingleCourseCellViewModel(state: .loading, cellType: .episode)
                cell.configure(model: viewModel)
            }
        }
        return cell
    }
    
}
