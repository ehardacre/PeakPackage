//
//  SwiftUIView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/28/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import Introspect
import WebKit

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
    
    @Published var messages : [DashboardMessage] = []
    
    public override init(){}
    
    public func loadMessage(){
        printr("manager reloading message")
        messages = []
        DatabaseDelegate.getDashboardMessage(){
            rex in
            printr("message loaded manager", tag: printTags.error)
            let mes = rex as! [DashboardMessage]
            self.messages = mes
            NotificationCenter.default.post(Notification(name: Notification.Name("dashboardMessageLoaded")))
        }
    }
}

public struct DashboardMessageCardView : View {

    @State var message : DashboardMessage
    
    @State var showWebView = false
    
    public var body : some View {
        HStack{
            Spacer()
            VStack{
                VStack{
                    Text(message.dashMessageTitle)
                        .CardTitle_light()
                        .foregroundColor(.lightAccent)
                    Text(message.dashMessageBody)
                        .Caption_light()
                }
                .padding(20)
                
                if message.dashMessageLink != "" {
                    HStack{
                        Spacer()
                        Image(systemName: "arrowshape.turn.up.right.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(Color.lightAccent)
                            .edgesIgnoringSafeArea(.bottom)
                            .edgesIgnoringSafeArea(.trailing)
                    }
                }
            }
            .padding(10)
            .background(Color.main)
            .cornerRadius(20)
            .onTapGesture {
                if message.dashMessageLink != "" {
                    showWebView = true
                }
            }
            Spacer()
        }
        .sheet(isPresented: $showWebView, content: {
            popUpWebView(urlStr: message.dashMessageLink)
        })
    }
}

public struct DashboardMessageShortView : View{
    
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var selection = 0
    
    @State var manager : DashboardManager
    @State var messages : [DashboardMessage] = []
    
    public var body: some View {
        LazyHStack{
            TabView(selection: $selection){
                ForEach(0..<messages.count){ i in
                    DashboardMessageCardView(message: messages[i])
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .onReceive(timer, perform: { _ in
                withAnimation{
                    print("selection is",selection)
                    selection = selection < (messages ?? []).count ? selection + 1 : 0
                }
            })
            .onReceive(
                NotificationCenter.default.publisher(
                    for: Notification.Name(rawValue: "database")),
                perform: {
                    note in
                    if let messages = note.object as? [DashboardMessage] {
                        printr("reseting message in view database call", tag: printTags.error)
                        self.messages = messages
                    }
            })
        }
//        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("dashboardMessageLoaded")), perform: { _ in
//            printr("reseting message in view", tag: printTags.error)
//            self.message = manager.message
//        })
    }
}

struct popUpWebView : View {
    
    @State var urlStr : String?
    @State var loading = true

    var body : some View {
        NavigationView{
                if urlStr != nil {
                    ZStack{
                        WebView(url: URL(string: urlStr!)!)
                        if loading {
                            ProgressView()
                                .onAppear{
                                    delayLoad()
                                }
                        }
                    }
                }else{
                    Text("Unable to load webpage.")
                        .Caption()
                }
        }
        .stackOnlyNavigationView()
    }
    
    private func delayLoad() {
        // Delay of 7.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            loading = false
        }
    }
}

struct WebView : UIViewRepresentable {
    
    let url: URL

    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webview = WKWebView()

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)

        return webview
    }

    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<WebView>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
    
}
