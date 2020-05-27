//
//  ChannelListViewModel.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

struct ChannelListViewModel {
    public func getSection() -> [SectionProtocol] {
        let episodeSection = NewEpisodesSection()
        let channelSection = ChannelSection()
        let categorySection = CategorySection()
        return [categorySection, episodeSection, channelSection]
    }
}
