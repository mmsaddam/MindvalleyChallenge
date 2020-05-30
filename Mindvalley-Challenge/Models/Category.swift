//
//  Category.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 30/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation


struct Category {
    let name: String
}

extension Category {
    init?(_ json: JSON) {
        guard let name = json["name"] as? String else { return nil }
        self.name = name
    }
}
