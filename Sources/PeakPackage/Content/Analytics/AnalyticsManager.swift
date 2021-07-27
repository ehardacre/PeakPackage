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
public class AnalyticsManager : Manager {
    
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
    //analytics still loading
    @Published var loading = true
    //keys for different attributes in the dictionary
    //just makes it easier to auto-fill
    static let totalEvents_key = "All Leads"
    static let visitors_key = "All Visitors"
    static let sessions_key = "PPC Visitors"
    static let sessionsWithEvent_key = "PPC Leads"
    static let adClicks_key = "Ad Clicks"
    static let adCost_key = "Ad Cost"
    static let costPerClick_key = "CPC"
    //the page names and page types for analytics view
    static let pages = [AnalyticsType.thisYear.displayName(),
                        AnalyticsType.thisMonth.displayName(),
                        AnalyticsType.thisWeek.displayName()]
    static let pages_types = [AnalyticsType.thisYear,
                              AnalyticsType.thisMonth,
                              AnalyticsType.thisWeek]
    
    public override init(){}
    
    ///the only call you need to make to load analytics
    func loadAnalytics(for type: AnalyticsType_general) {
        loadTempFromMidEnd(for: type)
        self.loading = true
        DatabaseDelegate.getAnalytics(for: type, completion: {
            rex in
            let analytics = rex as! [Analytics]
            self.separateAnalytics(analytics: analytics)
            self.loadGraphableData()
            self.loading = false
        })
    }
    
    private func loadTempFromMidEnd(for type: AnalyticsType_general){
        switch type {
        case .Day:
            todayData = MiddleEndDatabase.getDashboardAnalytics()?.data
        default:
            return
        }
    }
    
    ///separates the analytics objects into thisWeek, thisMosnth and Last Month
    private func separateAnalytics(analytics: [Analytics]){
        for lit in analytics {
            switch lit.title{
            case "Today" :
                todayData = lit.data
                MiddleEndDatabase.setDashboardAnalytics(analytics: lit)
                today.page?.totals = todayData?.page?.getTotals() ?? [:]
            case "ThisWeek" :
                thisWeekData = lit.data
            case "ThisMonth" :
                thisMonthData = lit.data
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



