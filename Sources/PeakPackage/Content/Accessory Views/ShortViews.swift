//
//  ShortViews.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 9/8/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI

//MARK: Analytics Short View
struct AnalyticsShortView : View {
    
    var parent : ContentView
    
    var body: some View {
        HStack{
            Spacer()
        VStack(alignment: .center){
            Text("Analytics").bold()
            Text("Today's Analytics").font(.system(.footnote)).foregroundColor(Color.gray)
            
            DashboardAnalytics(analyticsMan: parent.analyticsManager).padding(.vertical)
            
            //see more tasks
            Button(action: {
                self.parent.tab = tabs.analytics
            }, label: {
                Text("See More").foregroundColor(Color.main)
            })
        }
            Spacer()
        }
    }
}

//MARK: Leads Short View
struct LeadsShortView : View {
    
    var parent : ContentView
    
    @State var lead : Lead?
    
    var body: some View {
        HStack{
            Spacer()
        VStack(alignment: .center){
            Text("Scheduling").bold()
            Text("Upcoming Schedule").font(.system(.footnote)).foregroundColor(Color.gray)
            
            if let lead = parent.notificationManager.todaysScheduled().first {
                LeadCardView(selectionManager: SelectionManager(), notificationMan: parent.notificationManager, lead: lead)
                
                //see more tasks
                Button(action: {
                    self.parent.tab = tabs.leads
                }, label: {
                    Text("See More").foregroundColor(Color.main)
                }).padding(.top,100)
            }else{
                Text("No Scheduled Jobs Today.").foregroundColor(.darkAccent).font(.body).padding(50)
            }
                
        }
            Spacer()
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "database")), perform: {
            note in
            
            if let leads = note.object as? [Lead] {
                lead = parent.notificationManager.todaysScheduled().first
            }
            
        })
        .onAppear{
            lead = parent.notificationManager.todaysScheduled().first
        }
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
    @State private var dataSource : SwiftAnalyticsObject?

    //page and ppc are both optional, default is page
    public init(analyticsMan: AnalyticsManager) {
        
        //dataSource = analyticsMan.today
        self.analyticsMan = analyticsMan
        
    }
    
    var body: some View {
        
        VStack{
        
            HStack{
                //the text information about analytics
                
                if (dataSource?.page?.totals?[AnalyticsManager.visitors_key] != nil || dataSource?.page?.totals?[AnalyticsManager.totalEvents_key] != nil){
                
                    Spacer()
                    
                    VStack{
                        //visitors
                        Text(dataSource?.page?.totals?[AnalyticsManager.visitors_key] ?? "0")
                            .analyticsTotals_style()
                        Text("Visitors")
                            .analyticsTotals_Label_style()
                    }
                    
                    Spacer()
                    
                    VStack{
                        //total events
                        Text(dataSource?.page?.totals?[AnalyticsManager.totalEvents_key] ?? "0")
                            .analyticsTotals_style()
                        Text("Leads")
                            .analyticsTotals_Label_style()
                    }
                    
                    Spacer()
                
                }else{
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            
            }
        }.padding(20).cornerRadius(20.0).background(Color.lightAccent)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "database")), perform: {
            note in
        
            if let analytics = note.object as? [Analytics] {
                dataSource = analyticsMan.today
            }
        
        })
        .onAppear{
            dataSource = analyticsMan.today
        }
    }
}
