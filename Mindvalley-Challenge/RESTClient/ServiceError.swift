//
//  ServiceError.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 20/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noIntenetConnection
    case custom(String)
    case other
}

extension ServiceError {
    init(json: JSON) {
        if let message = json["message"] as? String {
            self = .custom(message)
        } else if let errors = json["errors"] as? [String], let message = errors.first {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}

extension ServiceError {
    init(error: Error) {
        self = .custom(error.localizedDescription)
    }
}


extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        case .noIntenetConnection:
            return "No internet connection"
        case .other:
            return "Something went wrong"
        }
    }
}
