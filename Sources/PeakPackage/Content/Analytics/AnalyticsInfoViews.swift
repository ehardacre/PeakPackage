//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/8/21.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct PageAnalyticsInfoView : View {
    
    @ObservedObject private var analyticsMan: AnalyticsManager
    
    @State var values = [ComparisonObject]()
    
    private var type: AnalyticsType
    
    //the data source for the analytics
    private var dataSource : (previous: SwiftAnalyticsObject?, now: SwiftAnalyticsObject?)?
    @State var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [], selectionColor: Color.red)
    
    //maybe a gradient would be nice some day
    private let chartStyle = ChartStyle(backgroundColor: .lightAccent, accentColor: .darkAccent, gradientColor: GradientColor(start: .darkAccent, end: .darkAccent), textColor: .darkAccent, legendTextColor: .darkAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    private let darkModeChartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Color.darkAccent, gradientColor: GradientColor(start: .main, end: .main), textColor: .darkAccent, legendTextColor: .lightAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    
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
                            values: dataSource?.now?.page?.graphableData ?? []),
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
                    DataTotals(fields: $values).onAppear{
                        if values.count == 0 {
                            for (key,value) in (dataSource?.now?.page?.totals ?? [:]) {
                                var previous = dataSource?.previous?.page?.totals?[key] ?? "0"
                                var comparison = ComparisonObject(key: key, value: value, previous: previous)
                                values.append(comparison)
                            }
                        }
                    }
                    
                    Spacer()
                
                }
            
                Spacer()
    
            }
            
            makeTextRecap()
        
        }.padding(20).background(Color.lightAccent).cornerRadius(20.0)
        
    }
    
    
    func makeTextRecap() -> some View {
        
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
        
        var recapString = "This \(timePeriod) your site has had "
        var first = true
        
        for (key,value) in (dataSource?.now?.page?.totals ?? [:]) {
            if !first {
                recapString += "and "
            }else{
                first = false
            }
            var previous = dataSource?.previous?.page?.totals?[key] ?? "0"
            var comparison = ComparisonObject(key: key, value: value, previous: previous)
            //values.append(comparison)
            recapString += "\(value) in the category \(key) (\(comparison.delta ?? "0%") from last \(timePeriod)'s \(previous ?? "0")) "
        }
        
        return Text(recapString).font(.footnote)
    }
    
}

struct PPCAnalyticsInfoView : View {
    
    @ObservedObject private var analyticsMan: AnalyticsManager
    
    @State var values = [ComparisonObject]()
    
    private var type: AnalyticsType
    
    //the data source for the analytics
    private var dataSource : (previous: SwiftAnalyticsObject?, now: SwiftAnalyticsObject?)?
    @State var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [], selectionColor: Color.red)
    
    //maybe a gradient would be nice some day
    private let chartStyle = ChartStyle(backgroundColor: .lightAccent, accentColor: .darkAccent, gradientColor: GradientColor(start: .darkAccent, end: .darkAccent), textColor: .darkAccent, legendTextColor: .darkAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    private let darkModeChartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Color.darkAccent, gradientColor: GradientColor(start: .main, end: .main), textColor: .darkAccent, legendTextColor: .lightAccent, dropShadowColor: Color.darkAccent.opacity(0.2))
    
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
                            values: dataSource?.now?.ppc?.graphableData ?? []),
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
                    DataTotals(fields: $values).onAppear{
                        if values.count == 0 {
                            for (key,value) in (dataSource?.now?.ppc?.totals ?? [:]) {
                                var previous = dataSource?.previous?.ppc?.totals?[key] ?? "0"
                                var comparison = ComparisonObject(key: key, value: value, previous: previous)
                                values.append(comparison)
                            }
                        }
                    }
                    Spacer()
                
                }
            
                Spacer()

            }
            
            makeTextRecap()
        
        }.padding(20).background(Color.lightAccent).cornerRadius(20.0)
        
    }
    
    
    func makeTextRecap() -> some View {
        
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
        
        var recapString = "This \(timePeriod) your site has had "
        var first = true
        
        for (key,value) in (dataSource?.now?.ppc?.totals ?? [:]) {
            if !first {
                recapString += "and "
            }else{
                first = false
            }
            var previous = dataSource?.previous?.ppc?.totals?[key] ?? "0"
            var comparison = ComparisonObject(key: key, value: value, previous: previous)
            //values.append(comparison)
            recapString += "\(value) in the category \(key) (\(comparison.delta ?? "0%") from last \(timePeriod)'s \(previous ?? "0")) "
        }
        
        return Text(recapString).font(.footnote)
    }
    
}

struct ComparisonObject{
    
    let id = UUID()
    var key : String?
    var value : String?
    var previous : String?
    var delta : String?
    
    init(key: String?, value: String?, previous: String?){
        self.key = key
        self.value = value
        self.previous = previous
        delta = calculateChange()
    }
    
    private func calculateChange() -> String?{
        guard let prevNum = previous?.digits.integer,
              let valNum = value?.digits.integer
              else { return nil }
        
        if prevNum == 0{
            return nil
        }
        
        var valueChange = Float(valNum - prevNum) / Float(prevNum) * 100
        var valueChangeStr = (valueChange > 0 ? "+" : "") + String(valueChange)
        return valueChangeStr.withDecimalPrecision(1) + "%"
    }
    
}

/**
 #Page Totals
 the text that appears inside of an analytics view
 describest the data totals for pages
 - Parameter totalEvents
 - Parameter visitors
 */
struct DataTotals : View {
    
    //the important values for page analytics
    @Binding var fields : [ComparisonObject]
    
    var body : some View {
        VStack(alignment: .leading){
            ForEach(fields, id: \.id){ obj in
                Text(obj.key ?? "")
                    .analyticsTotals_Label_style()
                Text(obj.value ?? "")
                    .analyticsTotals_style()
                Text(obj.delta ?? "")
                    .analyticsTotals_Past_style()
            }
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
