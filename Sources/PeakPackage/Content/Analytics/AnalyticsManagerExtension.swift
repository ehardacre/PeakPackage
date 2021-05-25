//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/17/21.
//

import Foundation
import SwiftUI

/**
 #Extension: Analytics Manager
 This extension manages the labeling for analytics manager
 */
extension AnalyticsManager{
    ///describes the time frame shown for weekly analytics
    func subtitleForWeek() -> String{
        let date = Date().addingTimeInterval(-86400)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return isFirstofWeek() ?
            "Monday - Sunday" :
            "Monday - \(formatter.string(from: date))"
    }
    func subnoteForWeek() -> String{
        return isFirstofWeek() ?
            "Not enough data has been collected this week, so this is last week's analytics."
            : ""
    }
    func isFirstofWeek() -> Bool{
        let date = Date()
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        return dayOfWeek == 1
    }
    
    ///describes the time frame shown for monthly analytics
    func subtitleForMonth() -> String{
        let date = Date()
        let prev_date = Date().addingTimeInterval(-86400)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMM d"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MMM"
        return isFirstofMonth() ?
            formatter.string(from: prev_date) :
            formatter3.string(from: date) + " 1 - "
            + formatter2.string(from: prev_date)
    }
    func subnoteForMonth() -> String{
        return isFirstofMonth() ?
            "Not enough data has been collected this month, so this is last month's analytics." :
            ""
    }
    func isFirstofMonth() -> Bool {
        let date = Date()
        let dayOfMonth = Calendar.current.component(.day, from: date)
        return dayOfMonth == 1
    }
    
    ///describes the time frame shown for yearly analytics
    func subtitleForYear() -> String{
        let date = Date()
        let prev_date = Date().addingTimeInterval(-2678400) //previous month
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMMM"
        return isFirstofYear() ?
            formatter.string(from: prev_date) :
            "January - " + formatter2.string(from: date)
        
    }
    func subnoteForYear() -> String{
        return isFirstofYear() ?
            "Not enough data has been collected this year, so this is last year's analytics." :
            ""
    }
    func isFirstofYear() -> Bool {
        let date = Date()
        let month = Calendar.current.component(.month, from: date)
        return month == 1
    }
}

//MARK: Analytics Type
/**
 #Analytics Type
 describes the time period for the analytics data
 google analytics separates the data into: this week, this month, and last month
 */
enum AnalyticsType_general{
    //generals
    case Day
    case Week
    case Month
    case Year
}
enum AnalyticsType {
    //specifics
    case thisWeek
    case thisMonth
    case thisYear
    case lastWeek
    case lastMonth
    case lastYear
    //need a null case as a blank initializer
    case null
    
    /**
    #Display Name
     gets the title text for the pages corresponding to the analytics types
     - Parameter full : (optional default false) full title or shortened title
     */
    func displayName(full: Bool = false) -> String{
        
        switch self {
        
        case .thisWeek :
            return full ? "This Week" : "Week"
            
        case .thisMonth :
            //we are now calling the sections this month and last month because
            //of confusion about why this months analytics aren't as good as last months
            return full ? "This Month" : "Month"
            //let date = Date()
            //return full ? date.fullMonth : date.abbreviatedMonth
        case .thisYear :
            return full ? "This Year" : "Year"
            //let date = Date(timeIntervalSinceNow: -1*60*60*24*30)
            //return full ? date.fullMonth : date.abbreviatedMonth
        default:
            return "none"
        }
    }
    
    /**
    #Expected Length
     used for the graphs, describes how many days the data is supposed to represent
     */
    func expectedLenght() -> Int{
        
        switch self {
        case .thisWeek:
            return 7
        case .lastWeek:
            return 7
        case .thisMonth:
            return 31
        case .lastMonth:
            return 31
        case .thisYear:
            return 12
        case .lastYear:
            return 12
        default:
            return 0
        }
    }
    
}

//MARK: Swift Analytics Object
/**
 #Swift Analytics Object
 this object is needed to hold the analytics data in a way that can be easily read into the display
 the decodable object from the backend didn't quite work for this
 */

struct SwiftAnalyticsObject {
    var page : Page?
    var ppc : PPC?
    
    init() {
        page = Page(graphableData: [], totals: [:])
        ppc = PPC(graphableData: [], totals: [:])
    }
}

struct Page {
    var graphableData : [(String, Int)]?
    var totals : [String : String]?
}

struct PPC {
    var graphableData : [(String, Int)]?
    var totals : [String : String]?
}
