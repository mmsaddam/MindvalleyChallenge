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
    
//    private func getViewModel() -> NewEpisodesCellViewModel {
//        var state: State<[Media]>
//        if isLoading {
//            state = State.loading
//        } else {
//            state = .loaded(episodes)
//        }
//        return NewEpisodesCellViewModel(state: state)
//
//    }
    
   private func getMaxHeight() -> CGFloat {
        let detaultHeight: CGFloat = 32 + 44 // Default title and channel name height
        if isLoading {
            return detaultHeight
        }
        return episodes.map { getTextHeight(for: $0) }.max() ?? detaultHeight
    }
    
    private func getTextHeight(for media: Media) -> CGFloat {
        let width = SingleCourseCell.itemWidth
        var totalHeight: CGFloat = 0
        let titleFont = UIFont(name: "Roboto-Regular", size: 17)!
        let titleHeight = media.title.getHeight(for: width , font: titleFont)
        totalHeight += titleHeight
        if let channelTitle = media.channelTitle {
            let channelFont = UIFont(name: "Roboto-Regular", size: 13)!
            let channelHeight = channelTitle.getHeight(for: width, font: channelFont)
            totalHeight += channelHeight
        }
        return totalHeight
        
    }
    
   private func cellHeight() -> CGFloat {
        let topMargin: CGFloat = 8
        let bottomMargin: CGFloat = 8
        let coverPhotoHeight: CGFloat = 228
        let internItemVertialSpacing: CGFloat = 10 + 12
        let itemTextHeight = getMaxHeight()
        return topMargin + bottomMargin + coverPhotoHeight + internItemVertialSpacing + itemTextHeight
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
        let viewModel = NewEpisodesCellViewModel(episodes: self.episodes)
        cell.configure(model: viewModel)
        return cell
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        return cellHeight()
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
