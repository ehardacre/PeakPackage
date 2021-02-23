//
//  SwiftUIView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/28/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import Introspect

struct TitleView: View {
    
    var title: String
    var actionTitle: Text
    var action: () -> Void
    
    init(_ title : String, actionTitle: Text = Text(""), action: @escaping ()->Void = {return}){
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.action()
                }, label: {
                    actionTitle
                })
            }.frame(height: 50)
            .background(Color.clear)
            HStack {
                Text(title).font(.largeTitle).bold().padding(.horizontal)
                Spacer()
            }
            .background(Color.clear)
        }
        .background(Color.clear)
    }
}

///the content that will be shown for the dashboard
public struct Content_Dashboard : PublicFacingContent {
    
    @ObservedObject public var manager: Manager
    
    init(manager: Manager) {
        self.manager = manager
    }
    
    var body : some View {
        ZStack{
            DashboardView(manager: manager as! DashboardManager)
            
        }
//        .sheet(isPresented: manager.showProfile){
//            ProfileView(showing: manager.showProfile)
//                .introspectViewController{
//                    $0.isModalInPresentation = manager.showProfile
//                }
//        }
    }
}
//extension ContentView {
//
//    func DashboardContent() -> some View {
//        ZStack{
//            DashboardView(parent: self)
//
//        }.sheet(isPresented: $showProfile){
//            ProfileView(showing: $showProfile)
//                .introspectViewController{
//                    $0.isModalInPresentation = showProfile
//                }
//        }
//    }
//}

/**
 #Home View
 this is the dashboard view TODO: dashboard might be a more apt name
 */
//MARK: Dashboard / HomeView
struct DashboardView: View {
    
    //the content view that hosts this dashboard
    @State var manager: DashboardManager
    
    var body: some View {
        
        NavigationView{
            
            List{
                
                DashboardMessageShortView(manager: manager)
                
                Divider()
                
               // LeadsShortView(parent: parent).listRowBackground(Color.clear)
                
                Divider()
                
                //AnalyticsShortView(parent: parent).listRowBackground(Color.clear)
                
                Divider()
                
            //LIST end
            }
            .listStyle(SidebarListStyle())
           .navigationBarTitle("Dashboard")
            .navigationBarItems(trailing:
            Button(action:{
                if defaults.admin{
                self.manager.showProfile = true
                }
            }){
                if defaults.admin{
                Image(systemName: "person.crop.circle").imageScale(.large).foregroundColor(.darkAccent)
                }
            })
            
        //NAVIGATION VIEW end
        }.background(Color.clear)
        .stackOnlyNavigationView()
    }
}

extension View {
    func stackOnlyNavigationView() -> some View {
        return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
    }
}

public class DashboardManager : Manager {
    
    @Published var showProfile = false
    @Published var message : DashboardMessage?
    
    public override init(){}
    
    func loadMessage(){
        if message == nil{
            DatabaseDelegate.getDashboardMessage(){
                rex in
                let mes = rex as! DashboardMessage
                self.message = mes
            }
        }
    }
}

struct DashboardMessageShortView : View{
    
    @State var manager : DashboardManager
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                
                Text(manager.message?.dashMessageTitle ?? "").font(.title3).bold().multilineTextAlignment(.center).foregroundColor(.white)
                Text(manager.message?.dashMessageBody ?? "").font(.body).foregroundColor(.white)
                
            }.padding(manager.message != nil ? 30 : 0).background(manager.message != nil ? Color.main : Color.clear).cornerRadius(20).onAppear{
                
                manager.loadMessage()
                
            }
            Spacer()
    }
    }
    
}
