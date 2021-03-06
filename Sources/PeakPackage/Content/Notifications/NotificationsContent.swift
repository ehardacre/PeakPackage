//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/17/21.
//

import SwiftUI

public struct Content_Leads_multiPage: PublicFacingContent {
    
    @ObservedObject public var manager : Manager
    @State var selectionMan = SelectionManager()
    @State var leadsIndex = 0
    
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        ZStack{
            switch leadsIndex {
            case 0:
            LeadsView_single(
                notificationMan: manager as! NotificationManager,
                selectionManager: selectionMan,
                title: "Open Leads",
                list: (manager as! NotificationManager).open_leads,
                loaded: (manager as! NotificationManager).loaded)
            
            case 1:
            LeadsView_single(
                notificationMan: manager as! NotificationManager,
                selectionManager: selectionMan,
                title: "Accepted",
                list: (manager as! NotificationManager).accepted_leads,
                loaded: (manager as! NotificationManager).loaded)

            case 2:
            LeadsView_single(
                notificationMan: manager as! NotificationManager,
                selectionManager: selectionMan,
                title: "Scheduled",
                list: (manager as! NotificationManager).scheduled_leads,
                loaded: (manager as! NotificationManager).loaded)
            default:
                EmptyView()
            }
            VStack{
                Spacer()
                if defaults.getApplicationType() == .NHanceConnect{
                    PageControl(
                        index: $leadsIndex,
                        maxIndex: NotificationManager.pages.count - 1,
                        pageNames: NotificationManager.pages,
                        dividers: true)
                }
            }
        }
    }
}

public struct Content_Orders: PublicFacingContent {
    
    @ObservedObject public var manager : Manager
    @ObservedObject var selectionManager = SelectionManager()
    
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        List{
            Text("Pending")
                .bold()
                .font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
                .overlay(
                    NotificationNumLabel(
                        number: (manager as! NotificationManager).newNotifications,
                        position: CGPoint(x: 55, y: 0)))
            if (manager as! NotificationManager).newNotifications == 0 {
                Text("No new orders to report right now.")
                    .foregroundColor(Color.secondary)
            }
            ForEach((manager as! NotificationManager).pending_orders,
                    id: \.notification_id){
                order in
                OrderCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! NotificationManager),
                    order: order)
            }
            Text("Processing")
                .bold()
                .font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
            ForEach(((manager as! NotificationManager).processing_orders),
                    id: \.notification_id){
                order in
                OrderCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! NotificationManager),
                    order: order)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(SidebarListStyle())
        .environment(\.defaultMinListRowHeight, 120).padding(0.0)
        .navigationTitle(Text("Orders"))
    }
}

public struct Content_Leads_singlePageSectioned: PublicFacingContent {
    
    @ObservedObject public var manager : Manager
    @ObservedObject var selectionManager = SelectionManager()
    
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        List{
            Text("New")
                .bold()
                .font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    NotificationNumLabel(
                        number: (manager as! NotificationManager).newNotifications,
                        position: CGPoint(x: 55, y: 0)))
            if (manager as! NotificationManager).newNotifications == 0 &&
                (manager as! NotificationManager).starredLeads == 0{
                Text("No new leads to report right now.")
                    .foregroundColor(Color.secondary)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach((manager as! NotificationManager).starred_leads,
                    id: \.notification_id){
                lead in
                LeadCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! NotificationManager),
                    lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach((manager as! NotificationManager).unread_leads,
                    id: \.notification_id){
                lead in
                LeadCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! NotificationManager),
                    lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text("Opened & Contacted")
                .bold()
                .font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
            ForEach(((manager as! NotificationManager).read_leads +
                        (manager as! NotificationManager).contacted_leads),
                    id: \.notification_id){
                lead in
                LeadCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! NotificationManager),
                    lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .listRowBackground(Color.clear)
        .listStyle(SidebarListStyle())
        .environment(\.defaultMinListRowHeight, 120)
        .padding(0.0)
        .navigationTitle(Text("Leads"))
    }
}

struct LeadsView_single : View {
    
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
                    ForEach(
                        list,
                        id: \.notification_id){
                        lead in
                        LeadCardView(
                            selectionManager: selectionManager,
                            notificationMan: notificationMan,
                            lead: lead)
                            .listRowBackground(Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    if list.count == 0{
                            Text("No \(title) leads to report right now.")
                                .foregroundColor(Color.secondary)
                                .listRowBackground(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer(minLength: 200)
                }
                .listRowBackground(Color.clear)
                .listStyle(SidebarListStyle())
                .environment(\.defaultMinListRowHeight, 120)
                .padding(0.0)
                .navigationTitle(Text(title))
            }else{
                ProgressView()
            }
        }
        .stackOnlyNavigationView()
    }
}
