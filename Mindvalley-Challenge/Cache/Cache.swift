//
//  Cache.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 22/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation
import UIKit

protocol Cacheable {
    func getData<T>(for key: String) -> T?
    func saveData<T>(_ data: T, for key: String) throws -> Void
}

/**
 UserDetault Cache
 */
final class Cache: Cacheable {
    
    func getData<T>(for key: String) -> T? {
        return nil
//        UserDefaults.standard.value(forKey: key) as? T
    }
    
    func saveData<T>(_ data: T, for key: String) throws -> Void {
//        UserDefaults.standard.set(data, forKey: key)
    }
    
}
