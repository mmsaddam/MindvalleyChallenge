//
//  Result.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 20/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(ServiceError?)
}
