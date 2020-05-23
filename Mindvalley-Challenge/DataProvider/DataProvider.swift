//
//  DataProvider.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 22/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation

protocol DataProviderProtocol: class {
    func getNewEpisodes(_ completion: @escaping ([Media]?) -> Void)
    func getChannels(_ completion: @escaping ([Channel]?) -> Void)
    func getCategories(_ completion: @escaping ([Category]?) -> Void)
}

final class DataProvier {
    class func factory() -> DataProviderProtocol {
        return MindValleyDataProvider()
    }
}


fileprivate final class MindValleyDataProvider: DataProviderProtocol {
    private var restClient: RESTClientProtocol
    private var cache: Cacheable
    
    enum Paths: String {
        case newEpisodes = "/z5AExTtw"
        case channels = "/Xt12uVhM"
        case categories = "/A0CgArX3"
    }
    
    init() {
        self.restClient = RESTClient(baseUrl: "https://pastebin.com/raw")
        self.cache = Cache()
    }
    
    func getNewEpisodes(_ completion: @escaping ([Media]?) -> Void) {
        let path = Paths.newEpisodes.rawValue
        
        if let mediaJson: JSON = cache.getData(for: path) {
            let allMedia = mediaJson.parseIntoMedia()
            completion(allMedia)
        } else {
            _ = restClient.sendRequest(path: path, method: .get, param: [:], completion: { [weak self] (result: Result<JSON>) in
                switch result {
                case .success(let json):
                    self?.saveIntoCache(json: json, for: path)
                    let allMedia: [Media]? = json.parseIntoMedia()
                    completion(allMedia)
                case .error( _ ):
                    completion(nil)
                }
            })
        }
    }
    
    func getChannels(_ completion: @escaping ([Channel]?) -> Void) {
        let path = Paths.channels.rawValue
        
        if let channelJson: JSON = cache.getData(for: path) {
            let channels = channelJson.parseIntoChannels()
            completion(channels)
        } else {
            _ = restClient.sendRequest(path: path, method: .get, param: [:]) { [weak self] (result: Result<JSON>) in
                switch result {
                case .success(let json):
                    self?.saveIntoCache(json: json, for: path)
                    let channels = json.parseIntoChannels()
                    completion(channels)
                case .error( _ ):
                    completion(nil)
                }
            }
        }
    }
    
    func getCategories(_ completion: @escaping ([Category]?) -> Void) {
        let path = Paths.categories.rawValue
        if let json: JSON = cache.getData(for: path) {
            completion(json.parseIntoCategories())
        } else {
            _ = restClient.sendRequest(path: path, method: .get, param: [:]) { [weak self] (result: Result<JSON>) in
                switch result {
                case .success(let json):
                    self?.saveIntoCache(json: json, for: path)
                    completion(json.parseIntoCategories())
                case .error( _ ):
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Conveninence
    private func saveIntoCache(json: JSON, for key: String) {
        do {
            try cache.saveData(json, for: key)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}






