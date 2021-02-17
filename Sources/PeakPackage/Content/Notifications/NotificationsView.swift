//
//  NotificationsView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/5/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

//struct NotificationsView: View {
//
//    @ObservedObject var notificationMan : NotificationManager
//    @State var selectionMan = SelectionManager()
//
//    @State var leadsIndex = 0
//
//    var body: some View {
//
//        ZStack{
//
////            if notificationMan.loaded {
//            if defaults.getApplicationType() == .NHanceConnect{
//                switch leadsIndex {
//
//                case 0:
//                LeadsView_NHance(notificationMan: notificationMan,
//                         selectionManager: selectionMan,
//                         title: "Open Leads",
//                         list: notificationMan.open_leads,
//                         loaded: notificationMan.loaded)
//
//                case 1:
//                LeadsView_NHance(notificationMan: notificationMan,
//                          selectionManager: selectionMan,
//                          title: "Accepted",
//                          list: notificationMan.accepted_leads,
//                          loaded: notificationMan.loaded)
//
//                case 2:
//                LeadsView_NHance(notificationMan: notificationMan,
//                          selectionManager: selectionMan,
//                          title: "Scheduled",
//                          list: notificationMan.scheduled_leads,
//                          loaded: notificationMan.loaded)
//                default:
//                    EmptyView()
//
//                }
//            }else if defaults.getApplicationType() == .PeakClients{
//                if defaults.woocommerce {
//                    OrdersView_Woo(notificationMan: notificationMan)
//                }else{
//                    LeadsView_Peak(notificationMan: notificationMan)
//                }
//            }
//
////            }else{
////                ProgressView()
////            }
//
//
//            VStack{
//
//                Spacer()
//
//                if defaults.getApplicationType() == .NHanceConnect{
//                    PageControl(index: $leadsIndex, maxIndex: NotificationManager.pages.count - 1, pageNames: NotificationManager.pages, dividers: true)
//                }
//
//            }
//        }
//        //TODO find another way to reload views
////        .onAppear{
////            notificationMan.loadNotifications()
////        }
//    }
//}
