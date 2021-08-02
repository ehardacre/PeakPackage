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
        LeadsStatsView(notificationMan: manager as! LeadManager)
//        ZStack{
//            switch leadsIndex {
//            case 0:
//            LeadsView_single(
//                notificationMan: manager as! LeadManager,
//                selectionManager: selectionMan,
//                title: "Open Leads",
//                list: (manager as! LeadManager).open_leads,
//                loaded: (manager as! LeadManager).loaded)
//
//            case 1:
//            LeadsView_single(
//                notificationMan: manager as! LeadManager,
//                selectionManager: selectionMan,
//                title: "Accepted",
//                list: (manager as! LeadManager).accepted_leads,
//                loaded: (manager as! LeadManager).loaded)
//
//            case 2:
//            LeadsView_single(
//                notificationMan: manager as! LeadManager,
//                selectionManager: selectionMan,
//                title: "Scheduled",
//                list: (manager as! LeadManager).scheduled_leads,
//                loaded: (manager as! LeadManager).loaded)
//            default:
//                EmptyView()
//            }
//            VStack{
//                Spacer()
//                if defaults.getApplicationType() == .NHanceConnect{
//                    PageControl(
//                        index: $leadsIndex,
//                        maxIndex: LeadManager.pages.count - 1,
//                        pageNames: LeadManager.pages,
//                        dividers: true)
//                }
//            }
//        }
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
                        number: (manager as! LeadManager).newNotifications,
                        position: CGPoint(x: 55, y: 0)))
            if (manager as! LeadManager).newNotifications == 0 {
                Text("No new orders to report right now.")
                    .foregroundColor(Color.secondary)
            }
            ForEach((manager as! LeadManager).pending_orders,
                    id: \.notification_id){
                order in
                OrderCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! LeadManager),
                    order: order)
            }
            Text("Processing")
                .bold()
                .font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
            ForEach(((manager as! LeadManager).processing_orders),
                    id: \.notification_id){
                order in
                OrderCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! LeadManager),
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
                        number: (manager as! LeadManager).newNotifications,
                        position: CGPoint(x: 55, y: 0)))
            if (manager as! LeadManager).newNotifications == 0 &&
                (manager as! LeadManager).starredLeads == 0{
                Text("No new leads to report right now.")
                    .foregroundColor(Color.secondary)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach((manager as! LeadManager).starred_leads,
                    id: \.notification_id){
                lead in
                LeadCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! LeadManager),
                    lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            ForEach((manager as! LeadManager).unread_leads,
                    id: \.notification_id){
                lead in
                LeadCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! LeadManager),
                    lead: lead)
                    .listRowBackground(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text("Opened & Contacted")
                .bold()
                .font(.title2)
                .listRowBackground(Color.clear)
                .foregroundColor(Color.darkAccent)
            ForEach(((manager as! LeadManager).read_leads +
                        (manager as! LeadManager).contacted_leads),
                    id: \.notification_id){
                lead in
                LeadCardView(
                    selectionManager: selectionManager,
                    notificationMan: (manager as! LeadManager),
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
    
    @State var notificationMan : LeadManager
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

struct LeadsStatsView : View {
    
    @State var notificationMan : LeadManager
    @State var leadSourceList : [leadSourceListElement] = []
    @State var loaded : Bool = false
    @State var colors : [Color] = [Color(red: Double(77)/Double(255), green: Double(157)/Double(255), blue: Double(224)/Double(255)),
                                      Color(red: Double(225)/Double(255), green: Double(85)/Double(255), blue: Double(84)/Double(255)),
                                      Color(red: Double(225)/Double(255), green: Double(188)/Double(255), blue: Double(41)/Double(255)),
                                      Color(red: Double(59)/Double(255), green: Double(178)/Double(255), blue: Double(115)/Double(255)),
                                      Color(red: Double(119)/Double(255), green: Double(104)/Double(255), blue: Double(174)/Double(255))]
    
    var body: some View {
        NavigationView{
            if loaded {
                List{
                    Text("To view specific leads, download the OnTrac App.")
                        .font(.caption)
                        .opacity(0.6)
                    HStack{
                        PieChartView(values: getValuesFromLeadSources(), colors: colors, backgroundColor: Color.lightAccent)
                            .frame(width: 200, height: 200)
                    }
                    .frame(height: 200)
                    .background(Color.lightAccent)
                    ForEach(0..<leadSourceList.count){ index in
                        HStack{
                            if index < colors.count {
                                Rectangle()
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(3)
                                    .foregroundColor(colors[index])
                            }else{
                                Rectangle()
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(3)
                                    .foregroundColor(colors.last)
                            }
                            Text(leadSourceList[index].source)
                                .bold()
                                .foregroundColor(Color.darkAccent)
                            Spacer()
                            Text("\(leadSourceList[index].count)")
                                .foregroundColor(Color.darkAccent)
                                .bold()
                            Text("(\(leadSourceList[index].percent)%)")
                                .foregroundColor(Color.darkAccent)
                                .font(.caption)
                        }
                        .padding(10)
                        .background(Color.lightAccent)
                        .cornerRadius(10)
                    }
                }
                .listRowBackground(Color.clear)
                .listStyle(SidebarListStyle())
                .padding(0.0)
                .navigationTitle(Text("Lead Statistics"))
            }else{
                ProgressView().onAppear{
                    if notificationMan.sortedLeadSources.count > 0 {
                        leadSourceList = notificationMan.sortedLeadSources
                        loaded = true
                    }
                }
            }
        }
        .stackOnlyNavigationView()
        .onReceive(NotificationCenter.default.publisher(for: LocalNotificationTypes.loadedLeadSources.postName()), perform: {
            _ in
            leadSourceList = notificationMan.sortedLeadSources
            loaded = true
        })
    }
    
    func getValuesFromLeadSources() -> [Double]{
        printr(leadSourceList)
        var list : [Double] = []
        for source in leadSourceList{
            list.append(Double(source.count))
        }
        return list
    }
}
