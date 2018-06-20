//
//  NetworkError.swift
//  DMT
//
//  Created by Dao Duy Duong on 6/11/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import Foundation
import ObjectMapper

class NetworkError: Model, Error {
    
    var code: String?
    var message: String?
    
    override func mapping(map: Map) {
        code <- map["error.code"]
        message <- map["error.message.value"]
    }
    
}






