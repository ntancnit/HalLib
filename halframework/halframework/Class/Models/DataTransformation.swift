//
//  DataTransformation.swift
//  Digital Maintenance Timestamp
//
//  Created by Do Trong Vuong on 6/5/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import Foundation
import ObjectMapper

public class TaskStatusTransform: TransformType {
    
    public typealias Object = TaskStatus
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? JSON {
            return Object(rawValue: value.capitalized) ?? .none
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.rawValue
    }
    
}

public class IntToStringTransform: TransformType {
    
    public typealias Object = String
    public typealias JSON = Int
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? JSON {
            return "\(value)"
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let value = value {
            return JSON(value)
        }
        return nil
    }
    
}








