//
//  DataManager.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import KeychainAccess


class DataManager {
    
    
    
    static let sharedManager: DataManager = DataManager()
    
    let varApplicationState = Variable<ApplicationState>(.none)
    
    private let keychain = Keychain(service: "com.fsu1.bu26.hal.HalBase")
    private var disposeBag: DisposeBag! = DisposeBag()
    
    
    func store<T: Any>(value: T, forKey key: String, complexKey: Bool = true) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: makeKey(from: key, complexKey: complexKey))
        defaults.synchronize()
    }
    
    func get<T>(forKey key: String, complexKey: Bool = true) -> T? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: makeKey(from: key, complexKey: complexKey)) as? T
    }
    
    func store<T: Model>(_ model: T?, forKey key: String, complexKey: Bool = true) {
        let defaults = UserDefaults.standard
        if let model = model {
            let json = Mapper<T>().toJSON(model)
            defaults.set(json, forKey: makeKey(from: key, complexKey: complexKey))
            defaults.synchronize()
        }
    }
    
    func load<T: Model>(forKey key: String, complexKey: Bool = true) -> T? {
        let defaults = UserDefaults.standard
        if let json = defaults.object(forKey: makeKey(from: key, complexKey: complexKey)) as? [String: AnyObject] {
            return Mapper<T>().map(JSON: json)
        }
        
        return nil
    }
    
    func storeArray<T: Model>(_ array: [T]?, forKey key: String, complexKey: Bool = true) {
        let defaults = UserDefaults.standard
        if let array = array {
            let json = Mapper<T>().toJSONArray(array)
            defaults.set(json, forKey: makeKey(from: key, complexKey: complexKey))
            defaults.synchronize()
        }
    }
    
    func loadArray<T: Model>(forKey key: String, complexKey: Bool = true) -> [T]? {
        let defaults = UserDefaults.standard
        if let json = defaults.object(forKey: makeKey(from: key, complexKey: complexKey)) as? [[String: AnyObject]] {
            return Mapper<T>().mapArray(JSONArray: json)
        }
        
        return nil
    }
    
    
    private func makeKey(from key: String, complexKey: Bool) -> String {
        return key
    }
}





