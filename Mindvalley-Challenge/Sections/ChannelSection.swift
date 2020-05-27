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
    

    private func textHight(for media: Media, width: CGFloat) -> CGFloat {
        let titleFont = UIFont(name: "Roboto-Regular", size: 17)!
        let titleHeight = media.title.getHeight(for: width , font: titleFont)
        return titleHeight
    }
    
    private func getFixHeight(_ isSeries: Bool) -> CGFloat {
        let topViewHeight: CGFloat = 82.0
        let colTopMargin: CGFloat = 8.0
        let colBottomMargin: CGFloat = 8.0
        let coverPhotoHeight: CGFloat = isSeries ? 172.0 : 228.0
        let itemSpacing: CGFloat = 10
        let totlaHeight = topViewHeight + colTopMargin + colBottomMargin + coverPhotoHeight + itemSpacing
        return totlaHeight
    }
    
    private func getMaxMediaTitleHeight(for channel: Channel) -> CGFloat {
        if channel.isSeries {
            return channel.series.map { textHight(for: $0, width: SingleSeriesCell.itemWidth) }.max() ?? 0.0
        } else {
            return channel.latestMedia.map { textHight(for: $0, width: SingleCourseCell.itemWidth) }.max() ?? 0.0
        }
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
        return channels.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView else { fatalError("tableView for episode section not found") }
        let channel = channels[indexPath.row]
        
        if channel.isSeries{
            let cell = table.dequeueReusableCell(withIdentifier: SeriesTableCell.reuseID(), for: indexPath) as! SeriesTableCell
            let viewModel = SeriesTableCellViewModel(channel: channel)
            cell.configure(model: viewModel)
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: ChannelCourseDesignCell.reuseID(), for: indexPath) as! ChannelCourseDesignCell
            let viewModel = ChannelCourseDesignCellViewModel(channel: channel)
            cell.configure(model: viewModel)
            return cell
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        let channel = channels[indexPath.row]
        let maxHeight = getMaxMediaTitleHeight(for: channel)
//        print("indexPath \(indexPath), height: \(getFixHeight(channel.series.count > 0) + maxHeight)")
        return getFixHeight(channel.isSeries) + maxHeight
    }
    
}
