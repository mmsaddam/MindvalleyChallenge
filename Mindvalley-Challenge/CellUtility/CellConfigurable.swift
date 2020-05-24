//
//  CellConfigurable.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

protocol CellConfigurable {
    associatedtype ModelType
    func configure(model: ModelType)
}
