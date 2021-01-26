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
    
    //show the action sheet to confirm franchise
    @State var showActionView = false
    @State var content : ContentView
    
    public init(content : ContentView){
        self.content = content
    }
    
    public var body: some View {
        VStack {
            if viewRouter.currentPage == LoginPages.content{
                //go to main content
                //ContentView()
                content
                    .environmentObject(AnalyticsManager())
                    .environmentObject(NotificationManager())
                    .environmentObject(DashboardMessageManager())
            }else if viewRouter.currentPage == LoginPages.standardLogin{
                //go to standard login
                LoginView(viewRouter: viewRouter)
            }else{
                Text("").onAppear{
                    printr(InternalError.viewLoading.rawValue, tag: printTags.error)
                }
            }
        }
    }
}
