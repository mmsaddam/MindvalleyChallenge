//
//  NewEpisodesSection.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

enum State<T> {
    case loading
    case loaded(T)
}

final class NewEpisodesSection {
    var id: String = "NewEpisodesSection"
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
    
    private func getViewModel() -> NewEpisodesCellViewModel {
        var state: State<[Media]>
        if isLoading {
            state = State.loading
        } else {
            state = .loaded(episodes)
        }
        return NewEpisodesCellViewModel(state: state)
        
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
        if isLoading {
            return 1
        } else {
            return episodes.count > 0 ? 1 : 0
        }
    }
    
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView else { fatalError("tableView for episode section not found") }
        let cell = table.dequeueReusableCell(withIdentifier: NewEpisodesCell.reuseID(), for: indexPath) as! NewEpisodesCell
        let viewModel = getViewModel()
        cell.configure(model: viewModel)
        return cell
    }
    
}
