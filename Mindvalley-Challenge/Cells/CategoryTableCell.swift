//
//  CategoryTableCell.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 27/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct CategoryTableCellViewModel {
    let categories:[Category]
    
    func category(for indexPath: IndexPath) -> Category? {
        if categories.indices.contains(indexPath.row) {
            return categories[indexPath.row]
        }
        return nil
    }
    
    func rowCount() -> Int {
        let rows = categories.count / 2 + categories.count % 2
        return rows
    }
    
}


final class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: "SingleCategoryCell", bundle: Bundle(for: SingleCategoryCell.self))
            collectionView.register(nib, forCellWithReuseIdentifier: "SingleCategoryCell")
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var collectionHeightConstraints: NSLayoutConstraint!
    
    private var viewModel: CategoryTableCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15.0
        layout.minimumLineSpacing = 15.0
        let width: CGFloat = (UIScreen.main.bounds.width - (30+15))/2
        layout.itemSize = CGSize(width: width, height: 60)
        collectionView.collectionViewLayout = layout
    }
    
    private func updateCollectionHeight(_ height: CGFloat) {
        collectionHeightConstraints.constant = height
        setNeedsUpdateConstraints()
    }
    
}

extension CategoryTableCell: CellConfigurable {
    typealias ModelType = CategoryTableCellViewModel
    
    func configure(model: CategoryTableCellViewModel) {
        self.viewModel = model
        let itemHeight: CGFloat = CGFloat(model.rowCount() * 60)
        let verticalSpace: CGFloat = CGFloat((model.rowCount() - 1) * 15)
        updateCollectionHeight(itemHeight + verticalSpace)
        collectionView.reloadData()
    }
}

extension CategoryTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleCategoryCell",
                                                      for: indexPath) as! SingleCategoryCell
        if let category = viewModel?.category(for: indexPath) {
            let viewModel = SingleCategoryCellViewModel(category: category)
            cell.configure(model: viewModel)
        }
        return cell
    }
    
}
