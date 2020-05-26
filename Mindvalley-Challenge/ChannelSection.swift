//
//  ChannelSection.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

final class ChannelSection {
    var id: String = "ChannelSection"
    weak var delegate: SectionUpdatingProtocol?
    private weak var tableView: UITableView?
    private var channels: [Channel] = []
    private var isLoading = false
    private var dataProvider: DataProviderProtocol
    private var loadingCount = 10
    
    init() {
        dataProvider = DataProvier.factory()
        fetchEpisoded()
    }
    
    private func fetchEpisoded() {
        isLoading = true
        dataProvider.getChannels { [weak self] (channels) in
            self?.channels = channels ?? []
            self?.isLoading = false
            self?.updateData()
        }
    }
    
    private func updateData() {
        delegate?.sectionDidUpdated(self)
    }
    
    private func getViewModel(for indexPath: IndexPath) -> ChannelCourseDesignCellViewModel? {
        if isLoading {
            return ChannelCourseDesignCellViewModel(state: .loading)
        } else {
            if channels.indices.contains(indexPath.row) {
                let channel = channels[indexPath.row]
                return ChannelCourseDesignCellViewModel(state: .loaded(channel))
            }
            
        }
        return nil
    }
    
}

extension ChannelSection: SectionProtocol {
    func setup(for tableView: UITableView?) -> Self {
        if self.tableView != tableView {
            self.tableView = tableView
        }
        
        let bundle = Bundle(for: ChannelCourseDesignCell.self)
        let episodesNib = UINib(nibName: "ChannelCourseDesignCell", bundle: bundle)
        tableView?.register(episodesNib, forCellReuseIdentifier: ChannelCourseDesignCell.reuseID())
        
        return self
    }
    
    func numberOfRows() -> Int {
        if isLoading {
            return loadingCount
        } else {
            return channels.count
        }
    }
    
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView else { fatalError("tableView for episode section not found") }
        let cell = table.dequeueReusableCell(withIdentifier: ChannelCourseDesignCell.reuseID(), for: indexPath) as! ChannelCourseDesignCell
        if let viewModel = getViewModel(for: indexPath) {
            cell.configure(model: viewModel)
        }
        
        return cell
    }
    
}
