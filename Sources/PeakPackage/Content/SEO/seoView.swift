//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/16/21.
//

import SwiftUI

public struct Content_SEO : PublicFacingContent {
    
    @ObservedObject var manager : Manager
    
    public init(manager: Manager){
        self.manager = manager
    }
    
    public var body : some View {
        seoView(manager: manager as! SEOManager)
    }
    
}

struct seoView: View {
    
    @State var manager : SEOManager
    @ObservedObject var selectionManager = SelectionManager()
    @State var loaded = false
    
    private let upSymbol = "arrow.up.circle.fill"
    private let downSymbol = "arrow.down.circle.fill"
    private let noChange = "circle.fill"
    
    var body: some View {
        NavigationView{
            List{
                if manager.rankings.count > 0 || loaded{
                    ForEach(manager.rankings, id: \.id){
                        rank in
                        seoCardView(
                            selectionManager: selectionManager,
                            manager: manager,
                            rank: rank)
                            .listRowBackground(Color.clear)
                    }
                }else{
                    HStack{
                        Spacer()
                        VStack{
                            ProgressView()
                            Text("Loading SEO Rankings...")
                                .bold()
                                .foregroundColor(.darkAccent)
                                .font(.footnote)
                                .padding(.top, 20)
                            Text("This can take a few minutes")
                                .font(.footnote)
                                .foregroundColor(.darkAccent)
                        }
                        Spacer()
                    }
                }
            }
            .CleanList()
            .navigationTitle("SEO Rankings")
        }
        .stackOnlyNavigationView()
        .onReceive(NotificationCenter.default.publisher(for: LocalNotificationTypes.loadedSEORanks.postName()), perform: { _ in
            loaded = true
        })
    }
}
