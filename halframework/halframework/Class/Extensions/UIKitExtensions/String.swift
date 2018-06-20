//
//  String.swift
//  DMT
//
//  Created by NGUYỄN THANH ÂN on 6/7/18.
//  Copyright © 2018 NGUYỄN THANH ÂN. All rights reserved.
//

import UIKit

extension String {
    
    typealias SimpleToFromRepalceList = [(fromSubString: String, toSubString: String)]
    
    private func simpleReplace( mapList:SimpleToFromRepalceList ) -> String {
        var string = self
        
        for (fromStr, toStr) in mapList {
            let separatedList = string.components(separatedBy: fromStr)
            if separatedList.count > 1 {
                string = separatedList.joined(separator: toStr)
            }
        }
        
        return string
    }
    
    var unescapedXml: String {
        let mapList : SimpleToFromRepalceList = [
            ("&amp;",  "&"),
            ("&quot;", "\""),
            ("&#x27;", "'"),
            ("&#39;",  "'"),
            ("&#x92;", "'"),
            ("&#x96;", "-"),
            ("&gt;",   ">"),
            ("&lt;",   "<")]
        
        return simpleReplace(mapList: mapList)
    }
    
    var percentEncodedUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    func convertHtml() -> String {
        guard let data = data(using: .utf8) else { return "" }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string
        } catch { }
        return ""
    }

}
