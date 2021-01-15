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
        }
    }
}
