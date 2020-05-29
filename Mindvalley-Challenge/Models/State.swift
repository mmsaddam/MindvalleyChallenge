//
//  State.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 29/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

enum State<T> {
    case loading
    case loaded(T)
}
