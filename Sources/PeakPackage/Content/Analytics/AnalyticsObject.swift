//
//  AnalyticsObject.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/19/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation

///this is the most broad object of the analytics return types
struct Analytics: Codable{
    //title is used to describe the time period being shown (eg. "thisWeek")
    var title: String?
    var data: Analytics_BreakDown?
}

///page and ppc data
struct Analytics_BreakDown: Codable{
    var page : GooglePageAnalytics?
    var ppc : GooglePPCAnalytics?
}

///describes what a GA data source should be able to do
protocol AnalyticsDataSource {
    func getGraphableData(for type: AnalyticsType) -> [(String, Int)]
    func getTotals() -> [String: String]
}

///the kinds of values google gives us for page analytics
struct GooglePageAnalytics: Codable , AnalyticsDataSource{
    var kind : String?
    var id : String?
    var query : GA_Query?
    var itemsPerPage : Int?
    var totalResults : Int?
    var selfLink : String?
    var profileInfo : GA_ProfileInfo?
    var containsSampledData : Bool?
    var columnHeaders : [GA_ColumnHeader]?
    var totalsForAllResults : GA_TotalsForAllResults_Page?
    var rows : [[String]]?
    
    ///given a type returns a dictionary that can be easily graphed
    func getGraphableData(for type: AnalyticsType) -> [(String,Int)]{
        if type == AnalyticsType.thisWeek || type == AnalyticsType.lastWeek {
            return graphAsWeek()
        }else if type == AnalyticsType.thisMonth || type == AnalyticsType.lastMonth {
            return graphAsMonth()
        }else{
            return graphAsYear()
        }
    }
    
    func graphAsWeek() -> [(String,Int)]{
        var graph : [(String, Int)] = []
        let daysOfWeek = ["Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                          "Saturday",
                          "Sunday"]
        var count = 0
        while count < 7{
            //day of the week
            let day = count < daysOfWeek.count ? daysOfWeek[count] : ""
            //day of week OR day of month
            let label = day
            var value = 0
            if count < (rows ?? []).count {
                let row = rows![count]
                value = Int(row[1]) ?? 0
            }
            graph.append((label,value))
            count += 1
        }
        return graph
    }
    
    func graphAsMonth() -> [(String,Int)]{
        var graph : [(String, Int)] = []
        var count = 0
        while count < 31{
            var value = 0
            var date = "0\(count + 1)"
            if count < (rows ?? []).count {
                let row = rows![count]
                value = Int(row[1]) ?? 0
                date = row[0]
            }
            let day = Date().abbreviatedMonth + " " + date.suffix(2)
            let label = day
            graph.append((label,value))
            count += 1
        }
        return graph
    }
    
    func graphAsYear() -> [(String,Int)]{
        var graph : [(String, Int)] = []
        var count = 0
        while count < 12{
            var value = 0
            var month = "0\(count)"
            if count < (rows ?? []).count {
                let row = rows![count]
                value = Int(row[1]) ?? 0
                month = row[0]
            }
            let day = "" + month.suffix(2)
            let label = day
            graph.append((label,value))
            count += 1
        }
        return graph
    }
    
    ///get the totals data from the analytics object
    func getTotals() -> [String: String] {
        var newTotals : [String: String] = [:]
        let totals = totalsForAllResults
        newTotals[AnalyticsManager.visitors_key] = totals?.gasessions
        newTotals[AnalyticsManager.totalEvents_key] = totals?.gasessionsWithEvent
        return newTotals
    }
}

///holds the return values for PPC analytics
struct GooglePPCAnalytics: Codable, AnalyticsDataSource{
    var kind : String?
    var id : String?
    var query : GA_Query?
    var itemsPerPage : Int?
    var totalResults : Int?
    var selfLink : String?
    var profileInfo : GA_ProfileInfo?
    var containsSampledData : Bool?
    var columnHeaders : [GA_ColumnHeader]?
    var totalsForAllResults : GA_TotalsForAllResults_PPC?
    var rows : [[String]]?
    
    ///given the type, returns a dictionary that can be easily graphed
    ///given a type returns a dictionary that can be easily graphed
    func getGraphableData(for type: AnalyticsType) -> [(String,Int)]{
        if type == AnalyticsType.thisWeek || type == AnalyticsType.lastWeek {
            return graphAsWeek()
        }else if type == AnalyticsType.thisMonth ||
                    type == AnalyticsType.lastMonth {
            return graphAsMonth()
        }else{
            return graphAsYear()
        }
    }
    
    func graphAsWeek() -> [(String,Int)]{
        var graph : [(String, Int)] = []
        let daysOfWeek = ["Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                          "Saturday",
                          "Sunday"]
        var count = 0
        while count < 7{
            //day of the week
            let day = count < daysOfWeek.count ? daysOfWeek[count] : ""
            //day of week OR day of month
            let label = day
            var value = 0
            if count < (rows ?? []).count {
                let row = rows![count]
                value = Int(row[2]) ?? 0
            }
            graph.append((label,value))
            count += 1
        }
        return graph
    }
    
    func graphAsMonth() -> [(String,Int)]{
        var graph : [(String, Int)] = []
        var count = 0
        while count < 31{
            var value = 0
            var date = "0\(count + 1)"
            if count < (rows ?? []).count {
                let row = rows![count]
                value = Int(row[2]) ?? 0
                date = row[0]
            }
            //day of the week
            let day = Date().abbreviatedMonth + " " + date.suffix(2)
            //day of week OR day of month
            let label = day
            graph.append((label,value))
            count += 1
        }
        return graph
    }
    
    func graphAsYear() -> [(String,Int)]{
        //the dictionary that will be returned
        var graph : [(String, Int)] = []
        var count = 0
        while count < 12{
            var value = 0
            var month = "0\(count)"
            if count < (rows ?? []).count {
                let row = rows![count]
                value = Int(row[2]) ?? 0
                month = row[0]
            }
            //day of the month
            let day = "" + month.suffix(2)
            //day of week OR day of month
            let label = day
            graph.append((label,value))
            count += 1
        }
        return graph
    }
    
    ///returns the totals for ppc analytics in a way that can be easily displayed
    func getTotals() -> [String : String] {
        var newTotals : [String : String] = [:]
        var totals = totalsForAllResults
        if totals != nil {
            if totals!.showingAdData(){
                newTotals[AnalyticsManager.adClicks_key] =
                    totals?.gaadClicks
                newTotals[AnalyticsManager.adCost_key] =
                    totals?.gaadCost?.withDecimalPrecision(1)
                newTotals[AnalyticsManager.costPerClick_key] =
                    totals?.gacostPerConversion?.withDecimalPrecision(1)
            }else if totals!.showingSessionData(){
                newTotals[AnalyticsManager.sessions_key] =
                    totals?.gasessions
                newTotals[AnalyticsManager.sessionsWithEvent_key] =
                    totals?.gasessionsWithEvent
            }
        }
        return newTotals
    }
}

//google specific return objects, I don't really do a lot with these they're just here to match the return type
struct GA_Query: Codable {
    var startdate : String?
    var enddate : String?
    var ids : String?
    var dimensions : String?
    var metrics : [String]?
    var startindex : Int?
    var maxresults : Int?
}

struct GA_ProfileInfo : Codable {
    var profileId : String?
    var accountId : String?
    var webPropertyId : String?
    var internalWebPropertyId : String?
    var profileName : String?
    var tableId : String?
}

struct GA_ColumnHeader : Codable {
    var name : String?
    var columnType : String?
    var dataType : String?
}

struct GA_TotalsForAllResults_Page : Codable {
    
    //NHANCE AND PEAK
    var gasessions : String//
    var gasessionsWithEvent : String//
    
    //WOOCOMMERCE
    var gatransactionRevenue : String?
    var gatransactions : String?
}

struct GA_TotalsForAllResults_PPC : Codable {
    
    //NHANCE
    var gasessionsWithEvent : String?
    var gasessions : String?
    
    //PEAK
    var gaadClicks : String?
    var gaadCost : String?
    var gacostPerConversion : String?
    
    func showingAdData() -> Bool {
        return
            (gaadClicks != nil && gaadCost != nil && gacostPerConversion != nil)
    }
    
    func showingSessionData() -> Bool{
        return
            (gasessionsWithEvent != nil && gasessions != nil)
    }
    
}



