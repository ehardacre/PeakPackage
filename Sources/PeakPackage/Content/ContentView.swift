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

protocol PublicFacingContent : View{
    var manager : Manager {get set}
    
    init(manager: Manager)
}

/**
 #Content View
 Content view holds all of the main content for the app
 */
public struct ContentView: View {
    
    var layout : AppLayout
    @State var availableTabs : [tabs]
    
    //tab for switching tabs
    @State var tab : tabs = tabs.dashboard
    
    //the indices for the page views
    @State var taskIndex = 0
    @State var showProfile = false
    
    //data managers
    @EnvironmentObject var analyticsManager : AnalyticsManager
    @EnvironmentObject var notificationManager : NotificationManager
    @EnvironmentObject var messageManager : DashboardMessageManager
    @EnvironmentObject var taskManager : TaskManager
    @EnvironmentObject var appointmentManager : AppointmentManager
    
    public init(layout: AppLayout) {
        
        self.layout = layout
        _availableTabs = State(initialValue: [])
        availableTabs = determineTabs()
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        //formatting table view (this might be deprecated but there's no harm in keeping it)
        UITableView.appearance().backgroundColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        UITableViewCell.appearance().backgroundColor = .clear
        UIListContentView.appearance().backgroundColor = .clear
        
    }

    func determineTabs() -> [tabs]{
        var temptabs : [tabs] = []
        if layout.DashboardView_exists{
            temptabs.append(tabs.dashboard)
        }
        if layout.AnalyticsView_exists{
            temptabs.append(tabs.analytics)
        }
        if layout.CalendarView_exists{
            temptabs.append(tabs.calendar)
        }
        if layout.TasksView_exists{
            temptabs.append(tabs.tasks)
        }
        if layout.LeadsView_exists{
            temptabs.append(tabs.leads)
        }
        return temptabs
    }
    
    public var body: some View {
        
        VStack(spacing: 0){
            
            ZStack{
                
                Color.black.opacity(0.05).edgesIgnoringSafeArea(.top)
                
                Section{
                    //manage tabs
                    if tab == tabs.analytics {

                        layout.AnalyticsView(manager: analyticsManager)

                    }else if tab == tabs.leads{

                        layout.LeadsView(manager: notificationManager)
                        
                    }else if tab == tabs.calendar{

                        layout.CalendarView(manager: appointmentManager)

                    }else if tab == tabs.tasks{
                        
                        layout.TasksView(manager: taskManager)

                    }else if tab == tabs.dashboard{

                        layout.DashboardView(manager: messageManager)

                    }
                }
                
            //ZSTACK end
            }.padding(.bottom,-35)
            
            TabMenu(tab: self.$tab, availableTabs: self.$availableTabs, notificationCount: notificationManager.newNotifications).shadow(color: Color.darkAccent.opacity(0.1), radius: 4, y: -4).frame(maxHeight: 70)
                .onAppear{
                    
                    analyticsManager.loadAnalytics(for: .Day)
                    analyticsManager.loadAnalytics(for: .Week)
                    notificationManager.loadNotifications()
                    if defaults.getApplicationType() == .PeakClients{
                        taskManager.loadTasks()
                        appointmentManager.loadAppointments()
                        appointmentManager.loadTodaysVisits()
                    }
                    
                }
            
        //VSTACK end
        }.background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.top))
        
    }
    
}


