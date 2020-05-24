//
//  CellReuseable.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

protocol CellReuseable {
    static func reuseID() -> String
}

extension UITableViewCell: CellReuseable {
    static func reuseID() -> String {
        return String(describing: self)
    }
}
