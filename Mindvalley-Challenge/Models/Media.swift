//
//  Media.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 20/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

struct Media {
    let title: String
    var channelTitle: String?
    var type: String?
    var coverUrl: URL?
}

extension Media {
    init?(_ json: JSON) {
        guard let title = json["title"] as? String else { return nil }
        
        self.title = title
        type = json["type"] as? String
        
        if let channel = json["channel"] as? JSON {
            channelTitle = channel["title"] as? String
        }
        
        if let coverAsset = json["coverAsset"] as? JSON, let urlStr = coverAsset["url"] as? String, let url = URL(string: urlStr) {
            coverUrl = url
        }
    }
}

struct Channel {
    let id: Int
    var title: String?
    var series: [Media] = []
    var mediaCount: Int?
    var iconUrl: URL?
    var coverUrl: URL?
}

extension Channel {
    init?(_ json: JSON) {
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String
            else { return nil }
        
        self.id = id
        self.title = title
        if let allSeries = json["series"] as? [JSON] {
            series = allSeries.compactMap(Media.init)
        }
        if let coverAsset = json["coverAsset"] as? JSON, let urlStr = coverAsset["url"] as? String, let url = URL(string: urlStr) {
            coverUrl = url
        }
        if let iconAsset = json["iconAsset"] as? JSON, let urlStr = iconAsset["thumbnailUrl"] as? String, let url = URL(string: urlStr) {
            iconUrl = url
        }
    }
}


struct Category {
    let name: String
}

extension Category {
    init?(_ json: JSON) {
        guard let name = json["name"] as? String else { return nil }
        self.name = name
    }
}

