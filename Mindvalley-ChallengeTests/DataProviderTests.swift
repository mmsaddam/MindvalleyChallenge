//
//  DataProviderTests.swift
//  Mindvalley-ChallengeTests
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import XCTest
@testable import Mindvalley_Challenge

class DataProviderTests: XCTestCase {
    var dataProvider: DataProviderProtocol?
    
    override func setUp() {
        dataProvider = DataProvier.factory()
    }
    
    override func tearDown() {
        dataProvider = nil
    }
    
    func testPerformanceNewEpisodes() {
        measure {
            dataProvider?.getNewEpisodes({ (medias) in
                XCTAssertNotNil(medias)
            })
        }
    }
    
    func testPerformanceChannels() {
        measure {
            dataProvider?.getChannels({ (channels) in
                XCTAssertNotNil(channels)
            })
        }
    }
    
    func testPerformanceCategory() {
        measure {
            dataProvider?.getCategories({ (categories) in
                XCTAssertNotNil(categories)
            })
        }
    }
    
}
