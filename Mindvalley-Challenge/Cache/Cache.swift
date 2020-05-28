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
 UserDetault UserDefaultCache
 */
final class UserDefaultCache: Cacheable {
    
    func getData<T>(for key: String) -> T? {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            return try? JSONSerialization.jsonObject(with: data, options: []) as? T
        }
        return nil
    }
    
    func saveData<T>(_ data: T, for key: String) throws -> Void {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            UserDefaults.standard.set(jsonData, forKey: key)
        } catch (let error) {
            throw error
        }
        
    }
    
}
