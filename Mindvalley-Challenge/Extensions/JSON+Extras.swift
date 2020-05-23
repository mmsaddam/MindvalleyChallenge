//
//  JSON+Extras.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

// MARK: - JSON parser helper

extension JSON {
    func parseIntoCategories() -> [Category]? {
        var categories: [Category]?
        if let data = self["data"] as? JSON, let catList = data["categories"] as? [JSON] {
            categories = catList.compactMap { return Category($0) }
        }
        return categories
    }
    
    func parseIntoMedia() -> [Media]? {
        var allMedia: [Media]?
        if let data = self["data"] as? JSON, let mediaList = data["media"] as? [JSON] {
            allMedia = mediaList.compactMap {  return Media($0) }
        }
        return allMedia
    }
    
    func parseIntoChannels() -> [Channel]? {
        var allChannel: [Channel]?
        if let data = self["data"] as? JSON, let channels = data["channels"] as? [JSON] {
            allChannel = channels.compactMap { return Channel($0) }
        }
        return allChannel
    }
}
