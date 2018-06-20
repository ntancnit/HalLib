//
//  NSErrorExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension NSError {
    
    static var Domain: String {
        return "com.halliburton.corp.error"
    }
    
    static var unknownError: NSError {
        return NSError(domain: Domain, code: 1000, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
    }
    
    static var mappingError: NSError {
        return NSError(domain: Domain, code: 1001, userInfo: [NSLocalizedDescriptionKey: "Cannot mapping response JSON to Object model"])
    }
    
    static func faultError(_ msg: String) -> NSError {
        return NSError(domain: Domain, code: 1003, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static var connectionError: NSError {
        return NSError(domain: Domain, code: 1004, userInfo: [NSLocalizedDescriptionKey: "No Connection"])
    }
    
    static var invalidResponseError: NSError {
        return NSError(domain: Domain, code: 1005, userInfo: [NSLocalizedDescriptionKey: "Invalid response JSON"])
    }
    
    static func permissionError(_ msg: String) -> NSError {
        return NSError(domain: Domain, code: 401, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
    static func tokenExpiredError(_ msg: String) -> NSError {
        return NSError(domain: Domain, code: 402, userInfo: [NSLocalizedDescriptionKey: msg])
    }
    
}









