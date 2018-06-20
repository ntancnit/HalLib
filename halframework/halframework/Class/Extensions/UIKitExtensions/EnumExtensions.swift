//
//  EnumExtensions.swift
//  Snapshot
//
//  Created by Hoang Lu on 3/12/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation

protocol CaseCountable {
    static var caseCount: Int { get }
}

extension CaseCountable where Self: RawRepresentable, Self.RawValue == Int {
    
    static var caseCount: Int {
        var count = 0
        while let _ = Self(rawValue: count) {
            count += 1
        }
        return count
    }
    
    static var cases: [Self] {
        return (0...caseCount).flatMap { Self(rawValue: $0) }
    }
    
}
