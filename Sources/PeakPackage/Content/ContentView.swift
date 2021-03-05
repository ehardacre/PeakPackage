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
    case seo = 4
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
    
    //var layout : AppLayout
    @State var availableTabs : [tabs]
    
    //tab for switching tabs
    @State var tab : tabs = tabs.dashboard
    
    //the indices for the page views
    @State var taskIndex = 0
    @State var showProfile = false
    @State var profileChanged = false
    
    //data managers
    @EnvironmentObject var analyticsManager : AnalyticsManager
    @EnvironmentObject var notificationManager : NotificationManager
    @EnvironmentObject var dashboardManager : DashboardManager
    @EnvironmentObject var taskManager : TaskManager
    @EnvironmentObject var appointmentManager : AppointmentManager
    @EnvironmentObject var seoManager : SEOManager
    @EnvironmentObject var profileManager : ProfileManager
    
    public init(tabs : [tabs]) {

        _availableTabs = State(initialValue: tabs)
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        //formatting table view (this might be deprecated but there's no harm in keeping it)
        UITableView.appearance().backgroundColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        UITableViewCell.appearance().backgroundColor = .clear
        UIListContentView.appearance().backgroundColor = .clear
        
    }

//    func determineTabs() -> [tabs]{
////        var temptabs : [tabs] = []
////        if layout.DashboardView_exists{
////            temptabs.append(tabs.dashboard)
////        }
////        if layout.AnalyticsView_exists{
////            temptabs.append(tabs.analytics)
////        }
////        if layout.CalendarView_exists{
////            temptabs.append(tabs.calendar)
////        }
////        if layout.TasksView_exists{
////            temptabs.append(tabs.tasks)
////        }
////        if layout.LeadsView_exists{
////            temptabs.append(tabs.leads)
////        }
//        if defaults.getApplicationType() == .NHanceConnect{
//            return [tabs.dashboard, tabs.analytics, tabs.leads, tabs.seo]
//        }else if defaults.getApplicationType() == .PeakClients{
//            return [tabs.dashboard, tabs.analytics, tabs.calendar, tabs.tasks, tabs.leads]
//        }
//        return []
//    }
    
    public var body: some View {
        
        VStack(spacing: 0){
            
            if profileChanged {
                HStack{
                    Spacer()
                    Text("\(defaults.franchiseName() ?? "")").bold().foregroundColor(Color.lightAccent).padding(20)
                    Spacer()
                }.background(Color.main)
            }
            
            ZStack{
                
                Color.black.opacity(0.05).edgesIgnoringSafeArea(.top)
                
                Section{
                    //manage tabs
                    if tab == tabs.analytics {

//                        layout.AnalyticsView(manager: analyticsManager)
                        Content_Analytics_multiPage(manager: analyticsManager)

                    }else if tab == tabs.leads{

                       // layout.LeadsView(manager: notificationManager)
                        if defaults.getApplicationType() == .NHanceConnect {
                            Content_Leads_multiPage(manager: notificationManager)
                        }else if defaults.getApplicationType() == .PeakClients {
                            Content_Leads_singlePageSectioned(manager: notificationManager)
                        }
                        
                    }else if tab == tabs.calendar{

                        //layout.CalendarView(manager: appointmentManager)
                        Content_Calendar(manager: appointmentManager)

                    }else if tab == tabs.tasks{
                        
                       // layout.TasksView(manager: taskManager)
                        Content_Tasks(manager: taskManager)

                    }else if tab == tabs.dashboard{

                        //layout.DashboardView(manager: dashboardManager)
                        Content_Dashboard(manager: dashboardManager, parent: self)

                    }else if tab == tabs.seo{
                        
                        Content_SEO(manager: seoManager)
                    }
                }
                
            //ZSTACK end
            }.padding(.bottom,-35)
            
            TabMenu(tab: self.$tab, availableTabs: self.$availableTabs, notificationCount: notificationManager.newNotifications).shadow(color: Color.darkAccent.opacity(0.1), radius: 4, y: -4).frame(maxHeight: 70)
                .onAppear{
                    NotificationCenter.default.post(Notification(name: Notification.Name("profileChanged"),object: nil))
                }
                .onReceive(
                    NotificationCenter.default.publisher(for: Notification.Name(rawValue: "profileChanged"))
                ){
                    note in
                    if note.object != nil{
                        profileChanged = true
                    }else{
                        profileChanged = false
                    }
                    profileManager.loadProfiles()
                    analyticsManager.loadAnalytics(for: .Day)
                    analyticsManager.loadAnalytics(for: .Week)
                    notificationManager.loadNotifications()
                    seoManager.loadRankings()
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


