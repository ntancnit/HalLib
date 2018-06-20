//
//  Util.swift
//  HealthCare
//
//  Created by Dao Duy Duong on 11/18/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import UIKit
import ObjectMapper
import WebKit


enum dateType : String {
    case date = "MM/dd/yyyy"
    case dateTime = "MM/dd/yyyy - h:mma"
    case modelTime = "yyyy-MM-dd'T'HH:mm:ss'Z'"
}
struct Util {
    
    static func transformResponses<T: GenericViewModel, M: Model>(_ responses: [M]?) -> [T] where T.ModelElement == M {
        
        if let responses = responses {
            return responses.flatMap { [T(model: $0)] }
        }
        
        return [T]()
        
    }
    
    
    static func UTCToLocalTime(dateToConvert: String, srcType: dateType, desType: dateType) -> String {
        if (dateToConvert == "") {
            return ""
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = srcType.rawValue
        dateFormatterGet.timeZone = TimeZone(abbreviation: "UTC")
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.dateFormat = desType.rawValue
        RFC3339DateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatterGet.date(from: dateToConvert), date > Date(timeIntervalSince1970: 0) {
            return RFC3339DateFormatter.string(from: date)
        } else {
            return ""
        }
        
    }
    
    static func LocalToUTCTime(dateToConvert: String, srcType: dateType, desType: dateType) -> String {
        if dateToConvert.isEmpty { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = srcType.rawValue
        formatter.calendar = NSCalendar.current
        formatter.timeZone = TimeZone.current
        
        if let dt = formatter.date(from: dateToConvert) {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = desType.rawValue
            
            return formatter.string(from: dt)
        }
        
        return ""
    }
    
    static func formatDateTime(date: Date, type: dateType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        return formatter.string(from: date)
    }
    
    static func convertToDateTime(fromString dateStr:String, type: dateType) -> Date?{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = type.rawValue
        
        return dateFormatterGet.date(from: dateStr)
    }
    
    static func convertToTime (fromDay days: String) -> String {
        if let numberOfDays = Double(days) {
            let hour = Int(numberOfDays * 24)
            let mins = Int((numberOfDays * 24 - Double(hour)) * 60)
            return "\(hour)h \(mins)m"
        }
        
        return "0h 0m"
    }
    
    static func convertToTime (fromHours hours: String) -> String {
        if let numberOfHours = Double(hours) {
            let hour = Int(numberOfHours)
            let mins = Int((numberOfHours - Double(hour)) * 60)
            return "\(hour)h \(mins)m"
        }
        
        return "0h 0m"
    }
    
    static func convertToTime (fromMinutes minutes: String) -> String {
        if let numberOfMinutes = Double(minutes) {
            let hour = Int(numberOfMinutes) / 60
            let mins = numberOfMinutes - Double(hour * 60)
            return "\(hour)h \(mins)m"
        }
        
        return "0h 0m"
    }
    
    static func convertToTime (fromSeconds seconds: String) -> String {
        if let numberOfSeconds = Double(seconds) {
            let hour = Int(numberOfSeconds) / 3600
            let mins = (Int(numberOfSeconds) - hour * 3600) / 60
            return "\(hour)h \(mins)m"
        }
        
        return "0h 0m"
    }
    
    
    static func convertToLongNumber(from value: Double, separator: String = ",") -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? ""   
    }

}
