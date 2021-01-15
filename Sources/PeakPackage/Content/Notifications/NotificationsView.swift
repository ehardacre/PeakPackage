//
//  NotificationsView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/5/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    
    @ObservedObject var notificationMan : NotificationManager
    @State var selectionMan = SelectionManager()
    
    @State var leadsIndex = 0
    
    var body: some View {
        
        ZStack{
            
            if notificationMan.loaded {
            
            //Pages for the analytics tab
            Pages_a(currentPage: $leadsIndex){
                

                LeadsView(notificationMan: notificationMan,
                         selectionManager: selectionMan,
                         title: "Open Leads",
                         list: notificationMan.open_leads,
                         loaded: notificationMan.loaded)
                
                LeadsView(notificationMan: notificationMan,
                          selectionManager: selectionMan,
                          title: "Accepted",
                          list: notificationMan.accepted_leads,
                          loaded: notificationMan.loaded)

                LeadsView(notificationMan: notificationMan,
                          selectionManager: selectionMan,
                          title: "Scheduled",
                          list: notificationMan.scheduled_leads,
                          loaded: notificationMan.loaded)
                
            }
                
            }else{
                ProgressView()
            }
            
            
            VStack{
                
                Spacer()
                
                PageControl(index: $leadsIndex, maxIndex: NotificationManager.pages.count - 1, pageNames: NotificationManager.pages, dividers: true)
                
            }
        }
        //TODO find another way to reload views
//        .onAppear{
//            notificationMan.loadNotifications()
//        }
    }
}

struct LeadsView : View {
    
    @State var notificationMan : NotificationManager
    @ObservedObject var selectionManager = SelectionManager()
    @State var title : String
    @State var list : [Lead]
    @State var loaded : Bool
    
    var body: some View {
        NavigationView{
            
            if loaded {
            
                List{
                    ForEach(list, id: \.notification_id){ lead in
                        LeadCardView(selectionManager: selectionManager, notificationMan: notificationMan, lead: lead)
                    }
                    if list.count == 0{
                            Text("No \(title) leads to report right now.").foregroundColor(Color.secondary)
                        }
                    
                    Spacer(minLength: 200)
                    }
                    .listStyle(SidebarListStyle())
                    .environment(\.defaultMinListRowHeight, 120).padding(0.0)
                    .navigationTitle(Text(title))
                
            }else{
                ProgressView()
            }
            }
            .stackOnlyNavigationView()
        }
    
    
    func addToList(lead: [Lead]){
        
    }
}
