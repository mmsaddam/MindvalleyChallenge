//
//  NewEpisodesCellViewModel.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation
import UIKit

struct NewEpisodesCellViewModel {
    let state: State<[Media]>
    
    func getMaxHeight() -> CGFloat? {
        if case let .loaded(episodes) = state {
            return episodes.map { getTextHeight(for: $0) }.max()
        }
        return nil
    }
    
    func getTextHeight(for media: Media) -> CGFloat {
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
    
}

