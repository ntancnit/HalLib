//
//  DependencyManager.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 4/3/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation

typealias RegistrationBlock = (() -> Any)
typealias GenericRegistrationBlock<T> = (() -> T)

protocol IMutableDependencyResolver {
    func getService(_ type: Any) -> Any?
    func register(_ factory: @escaping RegistrationBlock, type: Any)
}

extension IMutableDependencyResolver {
    
    func getService<T>() -> T {
        return getService(T.self) as! T
    }
    
    func register<T>(_ factory: @escaping GenericRegistrationBlock<T>) {
        return register({ factory() }, type: T.self)
    }
    
}

class DefaultDependencyResolver: IMutableDependencyResolver {
    
    private var registry = [String: RegistrationBlock]()
    
    func getService(_ type: Any) -> Any? {
        let k = String(describing: type)
        for key in registry.keys {
            if k.contains(key) {
                return registry[key]?()
            }
        }
        return nil
    }
    
    func register(_ factory: @escaping RegistrationBlock, type: Any) {
        let k = String(describing: type)
        registry[k] = factory
    }

}

class DependencyManager {
    
    static let sharedManager: DependencyManager = DependencyManager()
    
    private let resolver: IMutableDependencyResolver = DefaultDependencyResolver()
    
    func getService<T>() -> T {
        return resolver.getService()
    }
    
    func registerService<T>(_ factory: @escaping GenericRegistrationBlock<T>) {
        resolver.register(factory)
    }
    
}




