//
//  Configs.swift
//  phimbo
//
//  Created by Dao Duy Duong on 2/24/17.
//  Copyright © 2017 Nover. All rights reserved.
//

import UIKit

enum Environment: String {
    case development, stage, production, test
}

struct Api {
    
    static let environment: Environment = .development
    
    static var endpoint: String {
        return "http://spwest.corp.halliburton.com/sites/maint_timestamp/_api/"
    }
   
}
