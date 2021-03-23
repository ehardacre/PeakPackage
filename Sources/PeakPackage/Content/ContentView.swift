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
    @State var profileName = ""
    @State var profileChanged = false
    
    //data managers
    @ObservedObject var analyticsManager : AnalyticsManager
    @ObservedObject var notificationManager : NotificationManager
    @ObservedObject var dashboardManager : DashboardManager
    @ObservedObject var taskManager : TaskManager2
    @ObservedObject var appointmentManager : AppointmentManager
    @ObservedObject var seoManager : SEOManager
    @ObservedObject var profileManager : ProfileManager
    
    public init(tabs : [tabs],
                _ analytics : AnalyticsManager,
                _ notifications : NotificationManager,
                _ dashboard : DashboardManager,
                _ task : TaskManager2,
                _ appointments : AppointmentManager,
                _ seo : SEOManager,
                _ profile : ProfileManager) {

        _availableTabs = State(initialValue: tabs)
        analyticsManager = analytics
        notificationManager = notifications
        dashboardManager = dashboard
        taskManager = task
        appointmentManager = appointments
        seoManager = seo
        profileManager = profile
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        //formatting table view (this might be deprecated but there's no harm in keeping it)
        UITableView.appearance().backgroundColor = .init(red: 0.0,
                                                         green: 0.0,
                                                         blue: 0.0,
                                                         alpha: 0.1)
        UITableViewCell.appearance().backgroundColor = .clear
        UIListContentView.appearance().backgroundColor = .clear
        
    }
    
    public var body: some View {
        VStack(spacing: 0){
            if profileChanged {
                HStack{
                    Text("\(profileName)")
                        .bold()
                        .foregroundColor(Color.lightAccent)
                        .padding(.top, 50)
                        .padding(.horizontal,20)
                    Spacer()
                    Button(
                        action: {
                            profileManager.changeFranchise(
                                to: "1",
                                newURL: "test2018",
                                newName: "admin")
                            profileChanged = false
                    }){
                        Image(systemName: "xmark")
                            .foregroundColor(Color.lightAccent)
                            .padding(20)
                    }
                    .padding(.top, 50)
                }
                .background(Color.main)
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom,0)
            }
            ZStack{
                Color.black
                    .opacity(0.05)
                    .edgesIgnoringSafeArea(.top)
                Section{
                    //manage tabs
                    if tab == tabs.analytics {
                        Content_Analytics_multiPage(
                            manager: analyticsManager)
                    }else if tab == tabs.leads{
                        if defaults.getApplicationType() == .NHanceConnect {
                            Content_Leads_multiPage(
                                manager: notificationManager)
                        }else if defaults.getApplicationType() == .PeakClients {
                            Content_Leads_singlePageSectioned(
                                manager: notificationManager)
                        }
                    }else if tab == tabs.calendar{
                        Content_Calendar(
                            manager: appointmentManager)
                    }else if tab == tabs.tasks{
                        Content_Tasks2(
                            manager: taskManager)
                    }else if tab == tabs.dashboard{
                        Content_Dashboard(
                            manager: dashboardManager,
                            parent: self)
                    }else if tab == tabs.seo{
                        Content_SEO(manager: seoManager)
                    }
                }
                .padding(.top, profileChanged ? -50 : 0)
            }
            .padding(.bottom,-35)
            TabMenu(
                tab: self.$tab,
                availableTabs: self.$availableTabs,
                notificationCount: notificationManager.newNotifications)
                .shadow(
                    color: Color.darkAccent.opacity(0.1),
                    radius: 4, y: -4)
                .frame(maxHeight: 70)
                .onAppear{
                    NotificationCenter.default.post(
                        Notification(
                            name: Notification.Name("profileChanged"),
                            object: nil))
                }
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: Notification.Name(rawValue: "profileChanged"))
                ){
                    note in
                    if note.object == nil ||
                        note.object as? Int == 1 ||
                        defaults.franchiseName() ?? "" == "admin"{
                        profileChanged = false
                    }else{
                        profileChanged = true
                        profileName = defaults.franchiseName() ?? ""
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
        }
        .background(Color.black
                        .opacity(0.05)
                        .edgesIgnoringSafeArea(.top))
    }
}


