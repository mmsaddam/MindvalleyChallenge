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
    
    private func channel(for indexPath: IndexPath) -> Channel? {
        guard !isLoading else { return nil }
        if channels.indices.contains(indexPath.row) {
            let channel = channels[indexPath.row]
            return channel
        }
        return nil
    }
    
    
    private func isSeries(_ indexPath: IndexPath) -> Bool {
        if channels.indices.contains(indexPath.row) {
            let channel = channels[indexPath.row]
            return channel.series.count > 0
        }
        return false
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
        
        let seriesCellNib = UINib(nibName: "SeriesTableCell", bundle: bundle)
        tableView?.register(seriesCellNib, forCellReuseIdentifier: SeriesTableCell.reuseID())
        
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
        
        if let channel = channel(for: indexPath) {
            if channel.series.count > 0 {
                let cell = table.dequeueReusableCell(withIdentifier: SeriesTableCell.reuseID(), for: indexPath) as! SeriesTableCell
                let viewModel = SeriesTableCellViewModel(state: .loaded(channel))
                cell.configure(model: viewModel)
                return cell
            } else {
                let cell = table.dequeueReusableCell(withIdentifier: ChannelCourseDesignCell.reuseID(), for: indexPath) as! ChannelCourseDesignCell
                let viewModel = ChannelCourseDesignCellViewModel(state: .loaded(channel))
                cell.configure(model: viewModel)
                return cell
            }
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: ChannelCourseDesignCell.reuseID(), for: indexPath) as! ChannelCourseDesignCell
            let viewModel = ChannelCourseDesignCellViewModel(state: .loading)
            cell.configure(model: viewModel)
            return cell
        }
        
    }
    
}
