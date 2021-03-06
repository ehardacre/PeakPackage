//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/8/21.
//

import Foundation
import SwiftUI
import SwiftUICharts

/**
 #AnalyticsInfoView
 the card view that houses the analytics information
 */
struct AnalyticsInfoView : View {
    
    @ObservedObject private var analyticsMan: AnalyticsManager
    //comparison objects to manage change in analytics over time
    @State var values = [ComparisonObject]()
    //page or ppc analytics
    var ppc : Bool
    //week month or year
    private var type: AnalyticsType
    //the data source for the analytics
    private var dataSource :
        (previous: SwiftAnalyticsObject?,
         now: SwiftAnalyticsObject?)?
    @State var mockBarChartDataSet:
        BarChart.DataSet =
        BarChart.DataSet(elements: [], selectionColor: Color.red)
    //maybe a gradient would be nice some day
    private let chartStyle =
        ChartStyle(backgroundColor: .lightAccent,
                   accentColor: .darkAccent,
                   gradientColor: GradientColor(start: .darkAccent, end: .darkAccent),
                   textColor: .darkAccent,
                   legendTextColor: .darkAccent,
                   dropShadowColor: Color.darkAccent.opacity(0.2))
    private let darkModeChartStyle =
        ChartStyle(backgroundColor: Color.black,
                   accentColor: Color.darkAccent,
                   gradientColor: GradientColor(start: .main, end: .main),
                   textColor: .darkAccent,
                   legendTextColor: .lightAccent,
                   dropShadowColor: Color.darkAccent.opacity(0.2))
    
    public init(type: AnalyticsType, analyticsMan: AnalyticsManager, ppc: Bool) {
        
        self.type = type
        self.analyticsMan = analyticsMan
        self.ppc = ppc
        
        //choosing the proper datasource from the manager based on type
        switch type{
        case .thisWeek:
            self.dataSource = (previous: analyticsMan.lastWeek,
                               now: analyticsMan.thisWeek)
        case .thisMonth:
            self.dataSource = (previous: analyticsMan.lastMonth,
                               now: analyticsMan.thisMonth)
        case .thisYear:
            self.dataSource = (previous: analyticsMan.lastYear,
                               now: analyticsMan.thisYear)
        default:
            self.dataSource = nil
        }
        
        //making the chart appropriate for dark mode as well
        chartStyle.darkModeStyle = darkModeChartStyle
    }
    
    var body : some View {
        VStack{
            HStack{
                if ppc {
                    BarChartView(
                        data:
                            ChartData(
                                values:
                                    dataSource?.now?.ppc?.graphableData ?? []
                            ),
                        title: "PPC",
                        legend: "Visitors",
                        style: chartStyle,
                        dropShadow: false,
                        cornerImage: Image(systemName: "cursor.rays")
                    )
                    .overlay(
                        ProgressView()
                            .if(
                                (dataSource?.now?.ppc?.graphableData ?? [])
                                    .count != 0,
                                content:
                                    {
                                        view in
                                        view.hidden()
                                        //hide the progress view if there's data
                                    })
                    )
                }else{
                    BarChartView(
                         data:
                            ChartData(
                                values:
                                    dataSource?.now?.page?.graphableData ?? []),
                         title: "All",
                         legend: "Visitors",
                         style: chartStyle,
                         dropShadow: false,
                         cornerImage: Image(systemName: "person.3.fill")
                    )
                    .overlay(
                        ProgressView()
                            .if(
                                (dataSource?.now?.ppc?.graphableData ?? [])
                                    .count != 0,
                                content:
                                    {
                                        view in
                                        view.hidden()
                                        //hide the progress view if there's data
                                    })
                    )
                }
                
            
                //the text information about analytics
                VStack(alignment: .leading){
                    //the totals text for the page analytics
                    VStack(alignment: .leading){
                        ForEach(sortDisplayAnalytics(), id: \.id){
                            obj in
                            Text(obj.key ?? "")
                                .analyticsTotals_Label_style()
                            Text(obj.value ?? "")
                                .analyticsTotals_style()
                            Text(obj.delta ?? "")
                                .analyticsTotals_Past_style()
                        }
                    }
                    .onAppear{
                        if values.count == 0 {
                            if ppc {
                                for (key,value)
                                in (dataSource?.now?.ppc?.totals ?? [:])
                                {
                                    let previous =
                                        dataSource?.previous?.ppc?.totals?[key]
                                        ?? "0"
                                    let comparison =
                                        ComparisonObject(key: key,
                                                         value: value,
                                                         previous: previous)
                                    values.append(comparison)
                                }
                            }else{
                                for (key,value)
                                in (dataSource?.now?.page?.totals ?? [:])
                                {
                                    let previous =
                                        dataSource?.previous?.page?.totals?[key]
                                        ?? "0"
                                    let comparison =
                                        ComparisonObject(key: key,
                                                         value: value,
                                                         previous: previous)
                                    values.append(comparison)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            makeTextRecap()
        }
        .padding(20)
        .background(Color.lightAccent)
        .cornerRadius(20.0)
        
    }
    
    //sort the analytics so that the visitors section appears first
    func sortDisplayAnalytics() -> [ComparisonObject]{
        var temp : [ComparisonObject] = []
        for val in values{
            if (val.key ?? "").contains("Visitors") {
                temp.insert(val, at: 0)
            }else{
                temp.append(val)
            }
        }
        return temp
    }
    
    //make recap of the analytics data
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
        let data = ppc ?
            dataSource?.now?.ppc?.totals :
            dataSource?.now?.page?.totals
        
        for (key,value)
        in (data ?? [:])
        {
            if !first {
                recapString += "and "
            }else{
                first = false
            }
            let previous = (ppc ?
                                dataSource?.previous?.ppc?.totals?[key] :
                                dataSource?.previous?.page?.totals?[key]) ?? "0"
            let comparison = ComparisonObject(key: key,
                                              value: value,
                                              previous: previous)
            //add strings to the recap
            recapString += "\(value) in the category "
            recapString += "\(key) (\(comparison.delta ?? "0%") "
            recapString += "from last \(timePeriod)'s \(previous)) "
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
    
    //calculate the change that between the previous time period and now
    private func calculateChange() -> String?{
        guard let prevNum = previous?.digits.integer,
              let valNum = value?.digits.integer
              else
        {
            return nil
        }
        if prevNum == 0{
            return nil
        }
        let valueChange = Float(valNum - prevNum) / Float(prevNum) * 100
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
