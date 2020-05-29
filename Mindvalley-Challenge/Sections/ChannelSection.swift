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
        let colBottomMargin: CGFloat = 8.0
        let coverPhotoHeight: CGFloat = isSeries ? 172.0 : 228.0
        let itemSpacing: CGFloat = 10
        let totlaHeight = topViewHeight + colBottomMargin + coverPhotoHeight + itemSpacing
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
        
        let bundle = Bundle(for: TableViewCourseCell.self)
        let episodesNib = UINib(nibName: "TableViewCourseCell", bundle: bundle)
        tableView?.register(episodesNib, forCellReuseIdentifier: TableViewCourseCell.reuseID())
        
        let seriesCellNib = UINib(nibName: "TableViewSeriesCell", bundle: bundle)
        tableView?.register(seriesCellNib, forCellReuseIdentifier: TableViewSeriesCell.reuseID())
        
        return self
    }
    
    func numberOfRows() -> Int {
        return channels.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView else { fatalError("tableView for episode section not found") }
        let channel = channels[indexPath.row]
        
        if channel.isSeries{
            let cell = table.dequeueReusableCell(withIdentifier: TableViewSeriesCell.reuseID(), for: indexPath) as! TableViewSeriesCell
            let viewModel = TableViewSeriesCellViewModel(channel: channel)
            cell.configure(model: viewModel)
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: TableViewCourseCell.reuseID(), for: indexPath) as! TableViewCourseCell
            let viewModel = TableViewCourseCellViewModel(channel: channel)
            cell.configure(model: viewModel)
            return cell
        }
    }
    
}
