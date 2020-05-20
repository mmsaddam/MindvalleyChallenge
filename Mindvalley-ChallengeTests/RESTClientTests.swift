//
//  RESTClientTests.swift
//  Mindvalley-ChallengeTests
//
//  Created by Muzahidul Islam on 20/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import XCTest
@testable import Mindvalley_Challenge

final class RESTClientTests: XCTestCase {
    private var client: RESTClient?
    
    override func setUp() {
        client = RESTClient(baseUrl: "https://pastebin.com/raw")
    }
    
    func testNewEpisodesApi() {
        let path = "/z5AExTtw"
        
        let expectation = XCTestExpectation(description: #function)
        
        _ = client?.sendRequest(path: path, method: .get, param: [:], completion: { (result: Result<JSON>) in
            switch result {
            case .success(let json):
                var allMedia: [Media]?
                if let data = json["data"] as? JSON, let mediaList = data["media"] as? [JSON] {
                    allMedia = mediaList.compactMap {  return Media($0) }
                }
                XCTAssertTrue(allMedia != nil)
                expectation.fulfill()
            case .error(let error):
                XCTFail(error?.errorDescription ?? "")
                expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    
    func testChannelApi() {
        let path = "/Xt12uVhM"
        
        let expectation = XCTestExpectation(description: #function)
        
        _ = client?.sendRequest(path: path, method: .get, param: [:], completion: { (result: Result<JSON>) in
            switch result {
            case .success(let json):
                var allChannel: [Channel]?
                if let data = json["data"] as? JSON, let channels = data["channels"] as? [JSON] {
                    allChannel = channels.compactMap { return Channel($0) }
                }
                XCTAssertTrue(allChannel != nil)
                expectation.fulfill()
            case .error(let error):
                XCTFail(error?.errorDescription ?? "")
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    
    func testCategoryApi() {
        let path = "/A0CgArX3"
        
        let expectation = XCTestExpectation(description: #function)
        
        _ = client?.sendRequest(path: path, method: .get, param: [:], completion: { (result: Result<JSON>) in
            switch result {
            case .success(let json):
                typealias Category =  Mindvalley_Challenge.Category
                var categories: [Category]?
                if let data = json["data"] as? JSON, let catList = data["categories"] as? [JSON] {
                    categories = catList.compactMap { return Category($0) }
                }
                
                XCTAssertTrue(categories != nil)
                expectation.fulfill()
            case .error(let error):
                XCTFail(error?.errorDescription ?? "")
                expectation.fulfill()
            }
            
        })
        
        wait(for: [expectation], timeout: 5.0)
        
    }
    
}
