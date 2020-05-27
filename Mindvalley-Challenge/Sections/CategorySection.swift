//
//  CategorySection.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 27/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit


final class CategorySection {
    var id: String = "CategorySection"
    weak var delegate: SectionUpdatingProtocol?
    private weak var tableView: UITableView?
    private var categories: [Category] = []
    private var isLoading = false
    private var dataProvider: DataProviderProtocol
    private var loadingCount = 10
    
    init() {
        dataProvider = DataProvier.factory()
        fetchEpisoded()
    }
    
    private func fetchEpisoded() {
        isLoading = true
        dataProvider.getCategories { [weak self] (categories) in
            self?.categories = categories ?? []
            self?.isLoading = false
            self?.updateData()
        }
    }
    
    private func updateData() {
        delegate?.sectionDidUpdated(self)
    }
    
}

extension CategorySection: SectionProtocol {
    func setup(for tableView: UITableView?) -> Self {
        if self.tableView != tableView {
            self.tableView = tableView
        }
        
        let bundle = Bundle(for: CategoryTableCell.self)
        let episodesNib = UINib(nibName: "CategoryTableCell", bundle: bundle)
        tableView?.register(episodesNib, forCellReuseIdentifier: CategoryTableCell.reuseID())
        return self
    }
    
    func numberOfRows() -> Int {
        return categories.count > 0 ? 1 : 0
    }
    
    func heightForHeaderInSection() -> CGFloat {
        let header = SectionHeader.loadFromNib()
        header.title = "Categories"
        return header.bounds.size.height
    }
    
    func viewForHeaderInSection() -> UIView? {
        let header = SectionHeader.loadFromNib()
        header.title = "Categories"
        return header
    }
    
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView else { fatalError("tableView for category section not found") }
        let cell = table.dequeueReusableCell(withIdentifier: CategoryTableCell.reuseID(), for: indexPath) as! CategoryTableCell
        let viewModel = CategoryTableCellViewModel(categories: categories)
        cell.configure(model: viewModel)
        return cell
        
    }
    
}
