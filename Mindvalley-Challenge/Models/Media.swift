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




