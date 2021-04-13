//
//  SwiftUIView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/28/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import Introspect

/**
 #Title View
 */
public struct TitleView: View {
    
    var title: String
    var actionTitle: Text
    var action: () -> Void
    
    public init(_ title : String,
                actionTitle: Text = Text(""),
                action: @escaping ()->Void = {return}){
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.action()
                }, label: {
                    actionTitle
                })
            }
            .frame(height: 50)
            .background(Color.clear)
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                Spacer()
            }
            .background(Color.clear)
        }
        .background(Color.clear)
    }
}

///the content that will be shown for the dashboard
//could not conform to Public Facing Content
public struct Content_Dashboard : View {
    
    @State public var manager: DashboardManager
    @State public var parent: ContentView
    
    public var body : some View {
        ZStack{
            DashboardView(manager: manager, parent: parent)
        }
    }
}

/**
 #Home View
 this is the dashboard view 
 */
//MARK: Dashboard / HomeView
public struct DashboardView: View {
    
    //the content view that hosts this dashboard
    @State var manager: DashboardManager
    @State var parent: ContentView
    @State var showProfile = false
    
    public var body: some View {
        NavigationView{
            List{
                DashboardMessageShortView(manager: manager)
                Divider()
                LeadsShortView(parent: parent)
                    .listRowBackground(Color.clear)
                Divider()
                AnalyticsShortView(parent: parent)
                    .listRowBackground(Color.clear)
                Divider()
            }
            .listStyle(SidebarListStyle())
            .navigationBarTitle("Dashboard")
            .navigationBarItems(trailing:
            Button(action:{
                if defaults.admin{
                    self.showProfile = true
                }
            }){
                if defaults.admin{
                    Image(systemName: "person.crop.circle")
                        .imageScale(.large)
                        .foregroundColor(.darkAccent)
                }
            })
        }
        .background(Color.clear)
        .stackOnlyNavigationView()
        .sheet(isPresented: $showProfile){
            ProfileView(showing: $showProfile, manager: parent.profileManager)
                .introspectViewController{
                    $0.isModalInPresentation = showProfile
                }
        }
    }
}

extension View {
    func stackOnlyNavigationView() -> some View {
        return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
    }
}

public class DashboardManager : Manager {
    
    @StateObject var message : DashboardMessage?
    
    public override init(){}
    
    public func loadMessage(){
        message = nil
        DatabaseDelegate.getDashboardMessage(){
            rex in
            let mes = rex as! DashboardMessage
            self.message = mes
        }
    }
}

public struct DashboardMessageShortView : View{
    
    @State var manager : DashboardManager
    @State var message : DashboardMessage?
    
    public var body: some View {
        HStack{
            Spacer()
            VStack{
                Text(message?.dashMessageTitle ?? "")
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Text(message?.dashMessageBody ?? "")
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(Color.main)
            .cornerRadius(20)
            .onAppear{
                message = manager.message
            }
            Spacer()
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: Notification.Name(rawValue: "database")),
            perform: {
                note in
                if let message = note.object as? DashboardMessage {
                    self.message = message
                }
        })
    }
}
