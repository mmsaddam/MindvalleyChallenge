//
//  SectionHeader.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 27/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

class SectionHeader: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    class func loadFromNib() -> SectionHeader {
        return Bundle(for: SectionHeader.self).loadNibNamed("SectionHeader", owner: nil, options: [:])?.first! as! SectionHeader
    }
    
}
