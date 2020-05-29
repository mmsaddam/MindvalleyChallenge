//
//  NewEpisodesSection.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit


final class NewEpisodesSection {
    var id: String = "New Episodes"
    weak var delegate: SectionUpdatingProtocol?
    private weak var tableView: UITableView?
    private var episodes: [Media] = []
    private var isLoading = false
    private var dataProvider: DataProviderProtocol
    
    init() {
        dataProvider = DataProvier.factory()
        fetchEpisoded()
    }
    
    private func fetchEpisoded() {
        isLoading = true
        dataProvider.getNewEpisodes { [weak self] (episodes) in
            self?.episodes = episodes ?? []
            self?.isLoading = false
            self?.updateData()
        }
    }
    
    private func updateData() {
        delegate?.sectionDidUpdated(self)
    }
    
}

extension NewEpisodesSection: SectionProtocol {
    func setup(for tableView: UITableView?) -> Self {
        if self.tableView != tableView {
            self.tableView = tableView
        }
        
        let bundle = Bundle(for: NewEpisodesCell.self)
        let episodesNib = UINib(nibName: "NewEpisodesCell", bundle: bundle)
        tableView?.register(episodesNib, forCellReuseIdentifier: NewEpisodesCell.reuseID())
        
        return self
    }
    
    func numberOfRows() -> Int {
        return episodes.count > 0 ? 1 : 0
    }
    
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView else { fatalError("tableView for episode section not found") }
        let cell = table.dequeueReusableCell(withIdentifier: NewEpisodesCell.reuseID(), for: indexPath) as! NewEpisodesCell
        var state: State<[Media]>
        if isLoading {
            state = .loading
        } else {
            state = .loaded(episodes)
        }
        let viewModel = NewEpisodesCellViewModel(state: state)
        cell.configure(model: viewModel)
        
        return cell
    }
    
    func heightForHeaderInSection() -> CGFloat {
        guard episodes.count > 0 else { return 0.0 }
        let header = SectionHeader.loadFromNib()
        header.title = id
        return header.bounds.size.height
    }
    
    func viewForHeaderInSection() -> UIView? {
        guard episodes.count > 0 else { return UIView() }
        let header = SectionHeader.loadFromNib()
        header.title = id
        return header
    }
    
}
