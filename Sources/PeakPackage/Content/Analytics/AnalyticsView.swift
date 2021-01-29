//
//  AnalyticsView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/24/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import SwiftUICharts

///this is the content that is the analytics tab
extension ContentView {
    
    ///the content for the analytics tab. separated for simplicity
    func AnalyticsContent() -> some View {
        ZStack{
            //Pages for the analytics tab
//            Pages_a(currentPage: $analyticsIndex){
//
//
//
//
//
//                AnalyticsView(type: AnalyticsType.thisWeek, analyticsMan: analyticsManager)
//
//            }
            
            switch analyticsIndex{
            
            case 0:
                AnalyticsView(type: AnalyticsType.thisYear, analyticsMan: analyticsManager)
            case 1:
                AnalyticsView(type: AnalyticsType.thisMonth, analyticsMan: analyticsManager)
            case 2:
                AnalyticsView(type: AnalyticsType.thisWeek, analyticsMan: analyticsManager)
            default:
                EmptyView()
            }
            
            
            VStack{
                
                Spacer()
                
                PageControl(index: $analyticsIndex, maxIndex: AnalyticsManager.pages.count - 1, pageNames: AnalyticsManager.pages, dividers: true)
                
            }
        }
    }
    
}

/**
 #Analytics View
 the view that is used for each of the analytics pages
 - Parameter type : the analytics type to be shown
 - Parameter analyticsMan : the analytics manager that will manage the data
 */
struct AnalyticsView: View {
    
    //the type of analytics being shown
    var type : AnalyticsType
    
    //the analytics manager
    @State var analyticsMan : AnalyticsManager
    
    var body: some View {
        
        VStack{
            
            NavigationView{
                
                List{
                    
                    VStack(alignment: .leading){
                        if type == AnalyticsType.thisWeek {
                            Text(analyticsMan.subtitleForWeek()).font(.footnote).bold().foregroundColor(.darkAccent)
                            Text(analyticsMan.subnoteForWeek()).font(.footnote).foregroundColor(Color.darkAccent.opacity(0.5))
                        }else if type == AnalyticsType.thisMonth {
                            Text(analyticsMan.subtitleForMonth()).font(.footnote).bold().foregroundColor(.darkAccent)
                            Text(analyticsMan.subnoteForMonth()).font(.footnote).foregroundColor(Color.darkAccent.opacity(0.5))
                        }else{
                            Text(analyticsMan.subtitleForYear()).font(.footnote).bold().foregroundColor(.darkAccent)
                            Text(analyticsMan.subnoteForYear()).font(.footnote).foregroundColor(Color.darkAccent.opacity(0.5))
                        }
                    }
                    
                    //the page analytics view
                    //AnalyticsInfoView(type: type, analyticsMan: analyticsMan, page: true){}
                    //.listRowBackground(Color.clear)
                    
                    //the ppc analytics view
                    //AnalyticsInfoView(type: type, analyticsMan: analyticsMan, page: false){}
                    //.listRowBackground(Color.clear)
                    
                    PageAnalyticsInfoView(type: type, analyticsMan: analyticsMan)
                    PPCAnalyticsInfoView(type: type, analyticsMan: analyticsMan)
                    
                    Spacer(minLength: 50)
                    
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitle(type.displayName(full: true))
                .background(Color.clear)
            }
        }
        .stackOnlyNavigationView()
    }
}

struct PageAnalyticsInfoView : View {
    
    private var analyticsMan: AnalyticsManager
    
    private var type: AnalyticsType
    
    //the data source for the analytics
    private var dataSource : (previous: SwiftAnalyticsObject?, now: SwiftAnalyticsObject?)?
    @State var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [], selectionColor: Color.red)
    
    //maybe a gradient would be nice some day
    private let chartStyle = ChartStyle(backgroundColor: .lightAccent, accentColor: .darkAccent, gradientColor: GradientColor(start: .darkAccent, end: .darkAccent), textColor: .darkAccent, legendTextColor: .darkAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    private let darkModeChartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Color.darkAccent, gradientColor: GradientColor(start: .main, end: .main), textColor: .darkAccent, legendTextColor: .lightAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    
    @State var delta_visitors = ""
    @State var delta_events = ""
    
    public init(type: AnalyticsType, analyticsMan: AnalyticsManager) {
        self.type = type
        self.analyticsMan = analyticsMan
        
        //choosing the proper datasource from the manager based on type
        switch type{
        case .thisWeek:
            self.dataSource = (previous: analyticsMan.lastWeek, now: analyticsMan.thisWeek)
        case .thisMonth:
            self.dataSource = (previous: analyticsMan.lastMonth, now: analyticsMan.thisMonth)
        case .thisYear:
            self.dataSource = (previous: analyticsMan.lastYear, now: analyticsMan.thisYear)
        default:
            self.dataSource = nil
        }
        
        //making the chart appropriate for dark mode as well
        chartStyle.darkModeStyle = darkModeChartStyle
    }
    
    var body : some View {
        VStack{
            HStack{
            
                BarChartView(data: ChartData(
                            values: dataSource?.now?.page.graphableData ?? []),
                         title: "All",
                         legend: "Visitors",
                         style: chartStyle,
                         dropShadow: false,
                         cornerImage: Image(systemName: "person.3.fill")
                ).overlay(
                    ProgressView().progressViewStyle(CircularProgressViewStyle()).frame(width: 30, height: 30).if(!analyticsMan.loading, content: {view in view.hidden()})
                )
            
                //the text information about analytics
                VStack(alignment: .leading){
                    //the totals text for the page analytics
                        PageTotals(
                            prev_totalEvents: dataSource!.previous!.page.totals[AnalyticsManager.totalEvents_key],
                            prev_visitors: dataSource!.previous!.page.totals[AnalyticsManager.visitors_key],
                            totalEvents: dataSource!.now!.page.totals[AnalyticsManager.totalEvents_key],
                            visitors: dataSource!.now!.page.totals[AnalyticsManager.visitors_key],
                            delta_visitors: $delta_visitors,
                            delta_events: $delta_events
                        ).onAppear{
                            guard let prev_total = dataSource!.previous!.page.totals[AnalyticsManager.totalEvents_key]?.digits.integer,
                                  let prev_visitors = dataSource!.previous!.page.totals[AnalyticsManager.visitors_key]?.digits.integer,
                                  let total = dataSource!.now!.page.totals[AnalyticsManager.totalEvents_key]?.digits.integer,
                                  let visitors = dataSource!.now!.page.totals[AnalyticsManager.visitors_key]?.digits.integer
                                  else { return }
                            
                            if prev_visitors == 0 {
                                return
                            }
                            
                            var visitor_d = Float(visitors - prev_visitors) / Float(prev_visitors) * 100
                            var visitor_d_str = (visitor_d > 0 ? "+" : "") + String(visitor_d)
                            delta_visitors = visitor_d_str.withDecimalPrecision(1) + "%"
                            
                            if prev_total == 0 {
                                return
                            }
                            
                            var total_d = Float(total - prev_total) / Float(prev_total) * 100
                            var total_d_str = (total_d > 0 ? "+" : "") + String(total_d)
                            delta_events = total_d_str.withDecimalPrecision(1) + "%"
                        }
                    
                    Spacer()
                
                }
            
                Spacer()
    
            
            
            }
            
            makeTextRecap()
        
        }.padding(20).background(Color.lightAccent).cornerRadius(20.0)
        
    }
    
    
    func makeTextRecap() -> some View {
        
        guard let prev_total = dataSource!.previous!.page.totals[AnalyticsManager.totalEvents_key]?.digits.integer,
              let prev_visitors = dataSource!.previous!.page.totals[AnalyticsManager.visitors_key]?.digits.integer,
              let total = dataSource!.now!.page.totals[AnalyticsManager.totalEvents_key]?.digits.integer,
              let visitors = dataSource!.now!.page.totals[AnalyticsManager.visitors_key]?.digits.integer
              else { return Text("") }
        
        var timePeriod = ""
        switch type{
        
        case .thisWeek:
            timePeriod = "week"
        case .thisMonth:
            timePeriod = "month"
        case .thisYear:
            timePeriod = "year"
        default:
            timePeriod = "period"
        }
        
        
        return Text("This \(timePeriod) your site has attracted \(visitors) visitors (\(delta_visitors) from last \(timePeriod)'s \(prev_visitors)) and \(total) leads (\(delta_events) from last \(timePeriod)'s \(prev_total) ).").font(.footnote).foregroundColor(.darkAccent)
        
    }
    
}

struct PPCAnalyticsInfoView : View {
    
    private var analyticsMan: AnalyticsManager
    
    private var type: AnalyticsType
    
    //the data source for the analytics
    private var dataSource : (previous: SwiftAnalyticsObject?, now: SwiftAnalyticsObject?)?
    @State var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [], selectionColor: Color.red)
    
    //maybe a gradient would be nice some day
    private let chartStyle = ChartStyle(backgroundColor: .lightAccent, accentColor: .darkAccent, gradientColor: GradientColor(start: .darkAccent, end: .darkAccent), textColor: .darkAccent, legendTextColor: .darkAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    private let darkModeChartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Color.darkAccent, gradientColor: GradientColor(start: .main, end: .main), textColor: .darkAccent, legendTextColor: .lightAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    
    @State var delta_sessions = ""
    @State var delta_sessionsWithEvents = ""
    
    public init(type: AnalyticsType, analyticsMan: AnalyticsManager) {
        self.type = type
        self.analyticsMan = analyticsMan
        
        //choosing the proper datasource from the manager based on type
        switch type{
        case .thisWeek:
            self.dataSource = (previous: analyticsMan.lastWeek, now: analyticsMan.thisWeek)
        case .thisMonth:
            self.dataSource = (previous: analyticsMan.lastMonth, now: analyticsMan.thisMonth)
        case .thisYear:
            self.dataSource = (previous: analyticsMan.lastYear, now: analyticsMan.thisYear)
        default:
            self.dataSource = nil
        }
        
        //making the chart appropriate for dark mode as well
        chartStyle.darkModeStyle = darkModeChartStyle
    }
    
    var body : some View {
        VStack{
            HStack{
            
                BarChartView(data: ChartData(
                            values: dataSource?.now?.ppc.graphableData ?? []),
                         title: "PPC",
                         legend: "Visitors",
                         style: chartStyle,
                         dropShadow: false,
                         cornerImage: Image(systemName: "cursor.rays")
                ).overlay(
                    ProgressView().progressViewStyle(CircularProgressViewStyle()).frame(width: 30, height: 30).if(!analyticsMan.loading, content: {view in view.hidden()})
                )
            
                //the text information about analytics
                VStack(alignment: .leading){
                    //the totals text for the page analytics
                    PPCTotals(
                        prev_sessions: dataSource?.previous?.ppc.totals[AnalyticsManager.sessions_key],
                        prev_sessionsWithEvents: dataSource?.previous?.ppc.totals[AnalyticsManager.sessionsWithEvent_key],
                        sessions: dataSource?.now?.ppc.totals[AnalyticsManager.sessions_key],
                        sessionsWithEvents: dataSource?.now?.ppc.totals[AnalyticsManager.sessionsWithEvent_key],
                        delta_sessions: $delta_sessions,
                        delta_sessionsWithEvents: $delta_sessionsWithEvents
                    ).onAppear{
                        guard let prev_sessions = dataSource!.previous!.ppc.totals[AnalyticsManager.sessions_key]?.digits.integer,
                              let prev_sessionsWithEvent = dataSource!.previous!.ppc.totals[AnalyticsManager.sessionsWithEvent_key]?.digits.integer,
                              let sessions = dataSource!.now!.ppc.totals[AnalyticsManager.sessions_key]?.digits.integer,
                              let sessionsWithEvent = dataSource!.now!.ppc.totals[AnalyticsManager.sessionsWithEvent_key]?.digits.integer
                              else { return }
                        
                        if prev_sessionsWithEvent == 0{
                            return
                        }
                        
                        var sessionsWithEvent_d = Float(sessionsWithEvent - prev_sessionsWithEvent) / Float(prev_sessionsWithEvent) * 100
                        var sessionsWithEvent_d_str = (sessionsWithEvent_d > 0 ? "+" : "") + String(sessionsWithEvent_d)
                        delta_sessionsWithEvents = sessionsWithEvent_d_str.withDecimalPrecision(1) + "%"
                        
                        if prev_sessions == 0{
                            return
                        }
                        
                        var sessions_d = Float(sessions - prev_sessions) / Float(prev_sessions) * 100
                        var sessions_d_str = (sessions_d > 0 ? "+" : "") + String(sessions_d)
                        delta_sessions = sessions_d_str.withDecimalPrecision(1) + "%"
                    }
                    
                    Spacer()
                
                }
            
                Spacer()
    
            
            
            }
            
            makeTextRecap()
        
        }.padding(20).background(Color.lightAccent).cornerRadius(20.0)
        
    }
    
    
    func makeTextRecap() -> some View {
        
        guard let prev_sessions = dataSource!.previous!.ppc.totals[AnalyticsManager.sessions_key]?.digits.integer,
              let prev_sessionsWithEvent = dataSource!.previous!.ppc.totals[AnalyticsManager.sessionsWithEvent_key]?.digits.integer,
              let sessions = dataSource!.now!.ppc.totals[AnalyticsManager.sessions_key]?.digits.integer,
              let sessionsWithEvent = dataSource!.now!.ppc.totals[AnalyticsManager.sessionsWithEvent_key]?.digits.integer
              else { return Text("") }
        
        var timePeriod = ""
        switch type{
        
        case .thisWeek:
            timePeriod = "week"
        case .thisMonth:
            timePeriod = "month"
        case .thisYear:
            timePeriod = "year"
        default:
            timePeriod = "period"
        }
        
        
        return Text("This \(timePeriod) your PPC ads have attracted \(sessions) visitors (\(delta_sessions) from last \(timePeriod)'s \(prev_sessions)) and \(sessionsWithEvent) leads (\(delta_sessionsWithEvents) from last \(timePeriod)'s \(prev_sessionsWithEvent) ).").font(.footnote).foregroundColor(.darkAccent)
        
    }
    
}

/**
 #Analytics Info View
 smaller view that shows a singular section of analytics data
currently just a graph and some fields depending on the type
 - Parameter content : custom content for the view (TODO: not implmented yet)
 - Parameter analyticsMan : the analytics manager  for the data
 - Parameter type : the analytics type
 - Parameter page : optional, boolean for whether its page analytics or not (default true)
 - Parameter ppc : optional, boolean opposite of page
 
 */
struct DashboardAnalytics: View {
    
    //handles the data
    private var analyticsMan: AnalyticsManager
    
    //the data source for the analytics
    private var dataSource : SwiftAnalyticsObject?

    //page and ppc are both optional, default is page
    public init(analyticsMan: AnalyticsManager) {
        
        dataSource = analyticsMan.today
        self.analyticsMan = analyticsMan
        
    }
    
    var body: some View {
        
        VStack{
        
            HStack{
                //the text information about analytics
                
                Spacer()
                
                VStack{
                    //visitors
                    Text(dataSource!.page.totals[AnalyticsManager.visitors_key] ?? "0")
                        .analyticsTotals_style()
                    Text("Visitors")
                        .analyticsTotals_Label_style()
                }
                
                Spacer()
                
                VStack{
                    //total events
                    Text(dataSource!.page.totals[AnalyticsManager.totalEvents_key] ?? "0")
                        .analyticsTotals_style()
                    Text("Leads")
                        .analyticsTotals_Label_style()
                }
                
                Spacer()
            
            }
        }.padding(20).background(Color.lightAccent).cornerRadius(20.0)
    }
}

/**
 #Page Totals
 the text that appears inside of an analytics view
 describest the data totals for pages
 - Parameter totalEvents
 - Parameter visitors
 */
struct PageTotals : View {
    
    //the important values for page analytics
    
    var prev_totalEvents : String?
    var prev_visitors : String?
    
    var totalEvents : String?
    var visitors : String?
    
    @Binding var delta_visitors : String
    @Binding var delta_events : String
    
    var body : some View {
        VStack(alignment: .leading){
            
            //visitors
            Text(AnalyticsManager.visitors_key)
                .analyticsTotals_Label_style()
            Text(visitors ?? "")
                .analyticsTotals_style()
            Text(delta_visitors)
                .analyticsTotals_Past_style()
            
            //total events
            Text(AnalyticsManager.totalEvents_key)
                .analyticsTotals_Label_style()
            Text(totalEvents ?? "")
                .analyticsTotals_style()
            Text(delta_events)
                .analyticsTotals_Past_style()
            
        }
    }
}

/**
 #PPC Totals
 the text that appears inside of an analytics view
 describest the data totals for ppc
 - Parameter adclicks
 - Parameter adcost
 - Parameter costconversion
 */
struct PPCTotals : View {
    
    var prev_sessions : String?
    var prev_sessionsWithEvents : String?
    
    //the important values for ppc analytics
    var sessions : String?
    var sessionsWithEvents : String?
    
    @Binding var delta_sessions : String
    @Binding var delta_sessionsWithEvents : String
    
    var body : some View {
        VStack(alignment: .leading){
            
            //Ad clicks
            Text(AnalyticsManager.sessions_key)
                .analyticsTotals_Label_style()
            Text(sessions ?? "")
                .analyticsTotals_style()
            Text(delta_sessions)
                .analyticsTotals_Past_style()
            
            //ad cost
            Text(AnalyticsManager.sessionsWithEvent_key)
                .analyticsTotals_Label_style()
            Text(sessionsWithEvents ?? "")
                .analyticsTotals_style()
            Text(delta_sessionsWithEvents)
                .analyticsTotals_Past_style()
            
        
        }
    }
}

//MARK: Style

//text styles for analytics views
extension Text {
    
    func analyticsTotals_Label_style() -> some View {
        return self
            .bold()
            .font(.subheadline)
            .foregroundColor(.main)
    }
    
    func analyticsTotals_Past_style() -> some View {
        return self
            .bold()
            .font(.body)
            .foregroundColor(.darkAccent).opacity(0.5)
    }
    
    func analyticsTotals_style() -> some View {
        return self
            .bold()
            .font(.title2)
            .foregroundColor(.darkAccent)
    }
}

