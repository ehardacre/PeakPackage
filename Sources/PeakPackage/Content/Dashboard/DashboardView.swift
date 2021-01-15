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
extension ContentView {
    
    func DashboardContent() -> some View {
        ZStack{
            DashboardView(parent: self)
            
        }.sheet(isPresented: $showProfile){
            ProfileView(showing: $showProfile)
                .introspectViewController{
                    $0.isModalInPresentation = showProfile
                }
        }
    }
}

/**
 #Home View
 this is the dashboard view TODO: dashboard might be a more apt name
 */
//MARK: Dashboard / HomeView
struct DashboardView: View {
    
    //the content view that hosts this dashboard
    var parent: ContentView
    
    var body: some View {
        
        NavigationView{
            
            List{
                
                DashboardMessageShortView(parent: parent)
                
                Divider()
                
                LeadsShortView(parent: parent).listRowBackground(Color.clear)
                
                Divider()
                
                AnalyticsShortView(parent: parent).listRowBackground(Color.clear)
                
                Divider()
                
            //LIST end
            }
            .listStyle(SidebarListStyle())
           .navigationBarTitle("Dashboard")
            .navigationBarItems(trailing:
            Button(action:{
                if defaults.admin{
                self.parent.showProfile = true
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

class DashboardMessageManager : ObservableObject {
    
    @Published var message : DashboardMessage?
    
    func loadMessage(){
        if message == nil{
            let json = JsonFormat.getDashboardMessage.format()
            printr(json,tag: printTags.error)
            DatabaseDelegate.performRequest(with: json, ret: returnType.dashboardMessage, completion: {
                rex in
                let mes = rex as! DashboardMessage
                self.message = mes
            })
        }
    }
}

struct DashboardMessageShortView : View{
    
    @State var parent : ContentView
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                
                Text(parent.messageManager.message?.dashMessageTitle ?? "").font(.title3).bold().multilineTextAlignment(.center).foregroundColor(.white)
                Text(parent.messageManager.message?.dashMessageBody ?? "").font(.body).foregroundColor(.white)
                
            }.padding(parent.messageManager.message != nil ? 30 : 0).background(parent.messageManager.message != nil ? Color.main : Color.clear).cornerRadius(20).onAppear{
                
                parent.messageManager.loadMessage()
                
            }
            Spacer()
    }
    }
    
}
