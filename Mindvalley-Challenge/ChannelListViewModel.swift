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
        return [episodeSection]
    }
}
