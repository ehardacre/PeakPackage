//
//  NotificationsView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/5/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct NotificationsView: View {
    
    @ObservedObject var notificationMan : NotificationManager
    @State var selectionMan = SelectionManager()
    
    @State var leadsIndex = 0
    
    var body: some View {
        
        ZStack{
            
//            if notificationMan.loaded {
            if defaults.getApplicationType() == .NHanceConnect{
                switch leadsIndex {
                
                case 0:
                LeadsView_NHance(notificationMan: notificationMan,
                         selectionManager: selectionMan,
                         title: "Open Leads",
                         list: notificationMan.open_leads,
                         loaded: notificationMan.loaded)
                
                case 1:
                LeadsView_NHance(notificationMan: notificationMan,
                          selectionManager: selectionMan,
                          title: "Accepted",
                          list: notificationMan.accepted_leads,
                          loaded: notificationMan.loaded)

                case 2:
                LeadsView_NHance(notificationMan: notificationMan,
                          selectionManager: selectionMan,
                          title: "Scheduled",
                          list: notificationMan.scheduled_leads,
                          loaded: notificationMan.loaded)
                default:
                    EmptyView()
                
                }
            }else if defaults.getApplicationType() == .PeakClients{
                if defaults.woocommerce {
                    OrdersView_Woo(notificationMan: notificationMan)
                }else{
                    LeadsView_Peak(notificationMan: notificationMan)
                }
            }
                
//            }else{
//                ProgressView()
//            }
            
            
            VStack{
                
                Spacer()
                
                if defaults.getApplicationType() == .NHanceConnect{
                    PageControl(index: $leadsIndex, maxIndex: NotificationManager.pages.count - 1, pageNames: NotificationManager.pages, dividers: true)
                }
                
            }
        }
        //TODO find another way to reload views
//        .onAppear{
//            notificationMan.loadNotifications()
//        }
    }
}

struct LeadsView_NHance : View {
    
    @State var notificationMan : NotificationManager
    @ObservedObject var selectionManager = SelectionManager()
    @State var title : String
    @State var list : [Lead]
    @State var loaded : Bool
    
    @State var refreshing = false
    
    var body: some View {
        NavigationView{
            
            if loaded {
            
                List{
                    ForEach(list, id: \.notification_id){ lead in
                        LeadCardView(selectionManager: selectionManager, notificationMan: notificationMan, lead: lead)
                            .listRowBackground(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    if list.count == 0{
                            Text("No \(title) leads to report right now.").foregroundColor(Color.secondary)
                                .listRowBackground(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Spacer(minLength: 200)
                    }
                    .listRowBackground(Color.clear)
                    .listStyle(SidebarListStyle())
                    .environment(\.defaultMinListRowHeight, 120).padding(0.0)
                    .navigationTitle(Text(title))
                
            }else{
                ProgressView()
            }
            }
            .stackOnlyNavigationView()
            .pullToRefresh(isShowing: $refreshing){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    notificationMan.loadNotifications()
                    self.refreshing = false
                }
            }
        }
}

struct LeadsView_Peak : View {
    
    @State var notificationMan : NotificationManager
    @ObservedObject var selectionManager = SelectionManager()
    
    var body: some View {
        List{
            Text("New").bold().font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(NotificationNumLabel(number: notificationMan.newNotifications, position: CGPoint(x: 55, y: 0)))
            if notificationMan.newNotifications == 0 && notificationMan.starredLeads == 0{
                Text("No new leads to report right now.").foregroundColor(Color.secondary)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach(notificationMan.starred_leads, id: \.notification_id){ lead in
                LeadCardView(selectionManager: selectionManager, notificationMan: notificationMan, lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach(notificationMan.unread_leads, id: \.notification_id){ lead in
                LeadCardView(selectionManager: selectionManager, notificationMan: notificationMan, lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Text("Opened & Contacted").bold().font(.title2).listRowBackground(Color.clear).foregroundColor(Color.darkAccent)
            ForEach((notificationMan.read_leads + notificationMan.contacted_leads), id: \.notification_id){ lead in
                LeadCardView(selectionManager: selectionManager, notificationMan: notificationMan, lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .listRowBackground(Color.clear)
        .listStyle(SidebarListStyle())
        .environment(\.defaultMinListRowHeight, 120).padding(0.0)
        .navigationTitle(Text("Leads"))
    }
}

struct OrdersView_Woo : View {
    
    @State var notificationMan : NotificationManager
    @ObservedObject var selectionManager = SelectionManager()
    
    var body: some View {
        List{
            Text("Pending").bold().font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
                .overlay(NotificationNumLabel(number: notificationMan.newNotifications, position: CGPoint(x: 55, y: 0)))
            if notificationMan.newNotifications == 0 {
                Text("No new orders to report right now.").foregroundColor(Color.secondary)
            }
            ForEach(notificationMan.pending_orders, id: \.notification_id){ order in
                  OrderCardView(selectionManager: selectionManager, notificationMan: notificationMan, order: order)
            }
            
            Text("Processing").bold().font(.title2).listRowBackground(Color.clear).foregroundColor(Color.darkAccent)
            ForEach((notificationMan.processing_orders), id: \.notification_id){ order in
                OrderCardView(selectionManager: selectionManager, notificationMan: notificationMan, order: order)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(SidebarListStyle())
        .environment(\.defaultMinListRowHeight, 120).padding(0.0)
        .navigationTitle(Text("Orders"))
    }
}
