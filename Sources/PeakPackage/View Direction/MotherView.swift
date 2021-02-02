//
//  MotherView.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/23/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Mother View
public struct MotherView: View{
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var content : AnyView
    
    let pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("GoToContent"))
    
    public var body: some View {
        VStack {
            if viewRouter.currentPage == LoginPages.content{
                //go to main content
                content
//                    .environmentObject(AnalyticsManager())
//                    .environmentObject(NotificationManager())
//                    .environmentObject(DashboardMessageManager())
//                    .environmentObject(TaskManager())
                //.environmentObject(AppointmentManager())

            }else if viewRouter.currentPage == LoginPages.standardLogin{
                //go to standard login
                LoginView(viewRouter: viewRouter)
            }else{
                Text("").onAppear{
                    printr(InternalError.viewLoading.rawValue, tag: printTags.error)
                }
            }
        }.onReceive(pub){ note in
            viewRouter.currentPage = LoginPages.content
        }
    }
}
