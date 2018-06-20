//
//  StringExtensions.swift
//  Snapshot
//
//  Created by Dao Duy Duong on 12/4/17.
//  Copyright © 2017 Halliburton. All rights reserved.
//

import UIKit

extension String {
    
    // create URL
    var url: URL? {
        return URL(string: self)
    }
    
    // create URLRequest
    var urlRequest: URLRequest? {
        if let url = url {
            return URLRequest(url: url)
        }
        return nil
    }
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func transFormToXML() -> String {
        return self.replacingOccurrences(of: "&", with: "&amp;")
     }
    
    func regex(pattern: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
            let results = matches.map {
                String(self[Range($0.range, in: self)!])
            }
            return results.reduce("", +)
        } catch let error {
            print(error.localizedDescription)
        }
        return ""
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func addUnit(unit: String) -> String {
        return self == "" ? " " : "\(self) \(unit)"
    }
}




