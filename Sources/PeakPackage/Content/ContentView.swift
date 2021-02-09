//
//  ContentView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/8/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import Pages

//MARK: Content View

///the tabs values for the bottom menu
public enum tabs : Int{
    case analytics = 0
    case leads = 1
    case dashboard = 2
    case calendar = 3
    case ratings = 4
    case tasks = 5
}

/**
 #Content View
 Content view holds all of the main content for the app
 */
public struct ContentView: View {
    
    @State var availableTabs : [tabs]
    
    //tab for switching tabs
    @State var tab : tabs = tabs.dashboard
    
    //the indices for the page views
    @State var taskIndex = 0
    @State var analyticsIndex = 2
    @State var showProfile = false
    
    //data managers
    @EnvironmentObject var analyticsManager : AnalyticsManager
    @EnvironmentObject var notificationManager : NotificationManager
    @EnvironmentObject var messageManager : DashboardMessageManager
    @EnvironmentObject var taskManager : TaskManager
    @EnvironmentObject var appointmentManager : AppointmentManager
    
    public init(tabMenuOptions : [tabs]? = [tabs.analytics, tabs.dashboard, tabs.leads]) {
        
        _availableTabs = State(initialValue: tabMenuOptions!)
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        //formatting table view (this might be deprecated but there's no harm in keeping it)
        UITableView.appearance().backgroundColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        UITableViewCell.appearance().backgroundColor = .clear
        UIListContentView.appearance().backgroundColor = .clear
        
    }
    
    public var body: some View {
        
        VStack(spacing: 0){
            
            ZStack{
                
                Color.black.opacity(0.05).edgesIgnoringSafeArea(.top)
                
                Section{
                    //manage tabs
                    if tab == tabs.analytics {

                        AnalyticsContent()

                    }else if tab == tabs.leads{

                        //this one's pretty easy so we don't need an extension
                        //ProfileView()
                        NotificationsView(notificationMan: notificationManager)
                        
                        
                    }else if tab == tabs.calendar{

                        CallCalendarView(ascVisits: appointmentManager.appointments, content: self)

                    }else if tab == tabs.tasks{
                        
                        TaskContent()

                    }else if tab == tabs.dashboard{

                        DashboardContent()

                    }
                }
                
            //ZSTACK end
            }.padding(.bottom,-35)
            
            TabMenu(tab: self.$tab, availableTabs: self.$availableTabs, notificationCount: notificationManager.newNotifications).shadow(color: Color.darkAccent.opacity(0.1), radius: 4, y: -4).frame(maxHeight: 70)
                .onAppear{
                    
                    analyticsManager.loadAnalytics(for: .Day)
                    notificationManager.loadNotifications()
                    
                    
                }
            
        //VSTACK end
        }.background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.top))
        
    }
    
}


