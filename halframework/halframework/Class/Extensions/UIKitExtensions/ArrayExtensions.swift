//
//  ArrayExtensions.swift
//  Snapshot
//
//  Created by Lữ on 4/16/18.
//  Copyright © 2018 Halliburton. All rights reserved.
//

import Foundation

extension Array {
    
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
}
