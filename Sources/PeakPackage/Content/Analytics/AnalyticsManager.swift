//
//  AnalyticsManager.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/19/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation

//MARK: Analytics Manager
/**
 #Analytics Manager
 functionally manages all of the data required for analytics
 */
public class AnalyticsManager : ObservableObject {
    
    //private variables for data
    private var thisWeekData : Analytics_BreakDown?
    private var thisMonthData : Analytics_BreakDown?
    private var thisYearData : Analytics_BreakDown?
    
    private var lastWeekData : Analytics_BreakDown?
    private var lastMonthData : Analytics_BreakDown?
    private var lastYearData : Analytics_BreakDown?
    
    private var todayData : Analytics_BreakDown?
    
    //those get turned into the easy to read published variables
    @Published var thisWeek = SwiftAnalyticsObject()
    @Published var thisMonth = SwiftAnalyticsObject()
    @Published var thisYear = SwiftAnalyticsObject()
    
    @Published var lastWeek = SwiftAnalyticsObject()
    @Published var lastMonth = SwiftAnalyticsObject()
    @Published var lastYear = SwiftAnalyticsObject()
    
    @Published var today = SwiftAnalyticsObject()
    
    @Published var loading = true
    
    //keys for different attributes in the dictionary
    //just makes it easier to auto-fill

    static let totalEvents_key = "All Leads"
    static let visitors_key = "All Visitors"
    static let sessions_key = "PPC Visitors"
    static let sessionsWithEvent_key = "PPC Leads"
    static let adClicks_key = "Ad Clicks"
    static let adCost_key = "Ad Cost"
    static let costPerClick_key = "Cost per Click"
    
    //the page names and page types for analytics view
    static let pages = [AnalyticsType.thisYear.displayName(), AnalyticsType.thisMonth.displayName(), AnalyticsType.thisWeek.displayName()]
    static let pages_types = [AnalyticsType.thisYear, AnalyticsType.thisMonth, AnalyticsType.thisWeek]
    
    public init(){}
    
    ///the only call you need to make to load analytics
    func loadAnalytics(for type: AnalyticsType_general) {
        DatabaseDelegate.getAnalytics(for: type, completion: {
            rex in
            let analytics = rex as! [Analytics]
            self.separateAnalytics(analytics: analytics)
            self.loadGraphableData()
            self.loading = false
        })
    }
    
    ///separates the analytics objects into thisWeek, thisMonth and Last Month
    private func separateAnalytics(analytics: [Analytics]){
        
        for lit in analytics {
            
            switch lit.title{
            
            case "Today" :
                todayData = lit.data
                today.page?.totals = todayData?.page?.getTotals() ?? [:]

            //pretty
            case "ThisWeek" :
                thisWeekData = lit.data
            //self
            case "ThisMonth" :
                thisMonthData = lit.data
            //explanitory
            case "ThisYear" :
                thisYearData = lit.data
            
                
            case "LastWeek":
                lastWeekData = lit.data
            case "LastMonth":
                lastMonthData = lit.data
            case "LastYear":
                lastYearData = lit.data
            default:
                return
            }
        }
    }
    
    ///loads graphable data and totals for all types
    func loadGraphableData() {
        loadGraphableData(for: .thisWeek)
        loadGraphableData(for: .thisMonth)
        loadGraphableData(for: .thisYear)
        loadGraphableData(for: .lastWeek)
        loadGraphableData(for: .lastMonth)
        loadGraphableData(for: .lastYear)
    }
    
    func subtitleForWeek() -> String{
        let date = Date().addingTimeInterval(-86400)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return isFirstofWeek() ? "Monday - Sunday" : "Monday - \(formatter.string(from: date))"
    }
    
    func subnoteForWeek() -> String{
        return isFirstofWeek() ? "Not enough data has been collected this week, so this is last week's analytics." : ""
    }
    
    func isFirstofWeek() -> Bool{
        let date = Date()
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        return dayOfWeek == 1
    }
    
    func subtitleForMonth() -> String{
        let date = Date()
        let prev_date = Date().addingTimeInterval(-86400)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMM d"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "MMM"
        return isFirstofMonth() ? formatter.string(from: prev_date) : formatter3.string(from: date) + " 1 - " + formatter2.string(from: prev_date)
    }
    
    func subnoteForMonth() -> String{
        return isFirstofMonth() ? "Not enough data has been collected this month, so this is last month's analytics." : ""
    }
    
    func isFirstofMonth() -> Bool {
        let date = Date()
        let dayOfMonth = Calendar.current.component(.day, from: date)
        return dayOfMonth == 1
    }
    
    func subtitleForYear() -> String{
        let date = Date()
        let prev_date = Date().addingTimeInterval(-2678400) //previous month
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMMM"
        return isFirstofYear() ? formatter.string(from: prev_date) : "January - " + formatter2.string(from: date)
        
    }
    func subnoteForYear() -> String{
        return isFirstofYear() ? "Not enough data has been collected this year, so this is last year's analytics." : ""
    }
    
    func isFirstofYear() -> Bool {
        let date = Date()
        let month = Calendar.current.component(.month, from: date)
        return month == 1
    }
    
    ///loads graphable data and totals for the given type
    private func loadGraphableData(for type: AnalyticsType){
        switch type{
        case .thisWeek:
            thisWeek.page?.graphableData = thisWeekData?.page?.getGraphableData(for: type) ?? []
            thisWeek.page?.totals = thisWeekData?.page?.getTotals() ?? [:]
            thisWeek.ppc?.graphableData = thisWeekData?.ppc?.getGraphableData(for: type) ?? []
            thisWeek.ppc?.totals = thisWeekData?.ppc?.getTotals() ?? [:]
        case .thisMonth:
            thisMonth.page?.graphableData = thisMonthData?.page?.getGraphableData(for: type) ?? []
            thisMonth.page?.totals = thisMonthData?.page?.getTotals() ?? [:]
            thisMonth.ppc?.graphableData = thisMonthData?.ppc?.getGraphableData(for: type) ?? []
            thisMonth.ppc?.totals = thisMonthData?.ppc?.getTotals() ?? [:]
        case.thisYear:
            thisYear.page?.graphableData = thisYearData?.page?.getGraphableData(for: type) ?? []
            thisYear.page?.totals = thisYearData?.page?.getTotals() ?? [:]
            thisYear.ppc?.graphableData = thisYearData?.ppc?.getGraphableData(for: type) ?? []
            thisYear.ppc?.totals = thisYearData?.ppc?.getTotals() ?? [:]
        case.lastWeek:
            lastWeek.page?.graphableData = lastWeekData?.page?.getGraphableData(for: type) ?? []
            lastWeek.page?.totals = lastWeekData?.page?.getTotals() ?? [:]
            lastWeek.ppc?.graphableData = lastWeekData?.ppc?.getGraphableData(for: type) ?? []
            lastWeek.ppc?.totals = lastWeekData?.ppc?.getTotals() ?? [:]
        case .lastMonth:
            lastMonth.page?.graphableData = lastMonthData?.page?.getGraphableData(for: type) ?? []
            lastMonth.page?.totals = lastMonthData?.page?.getTotals() ?? [:]
            lastMonth.ppc?.graphableData = lastMonthData?.ppc?.getGraphableData(for: type) ?? []
            lastMonth.ppc?.totals = lastMonthData?.ppc?.getTotals() ?? [:]
        case .lastYear:
            lastYear.page?.graphableData = lastYearData?.page?.getGraphableData(for: type) ?? []
            lastYear.page?.totals = lastYearData?.page?.getTotals() ?? [:]
            lastYear.ppc?.graphableData = lastYearData?.ppc?.getGraphableData(for: type) ?? []
            lastYear.ppc?.totals = lastYearData?.ppc?.getTotals() ?? [:]
    
        default:
            return
        }
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
     TODO: I don't think this will run into any problems but the months just return 31, it could be improved by returning the actual number of days in the month
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

