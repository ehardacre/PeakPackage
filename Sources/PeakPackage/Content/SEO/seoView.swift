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
    
    let upSymbol = "arrow.up.circle.fill"
    let downSymbol = "arrow.down.circle.fill"
    let noChange = "circle.fill"
    
    var body: some View {
        NavigationView{
            List{
                HStack{
                    Text("Search Term").bold().font(.footnote).foregroundColor(.darkAccent).opacity(0.5)
                    Spacer()
                    Text("Rank").font(.footnote).foregroundColor(.darkAccent).opacity(0.5)
                }
                ForEach(manager.rankings, id: \.id){ rank in
                    
                    HStack{
                        Text(rank.term)
                        Spacer()
                        Text(rank.organic_rank)
                        Image(systemName: rank.change == nil ? noChange : rank.change! ? upSymbol : downSymbol)
                    }
                    
                }
            }
            .listStyle(SidebarListStyle())
            .cornerRadius(10.0)
            .navigationTitle("SEO Rankings")
        }
    }
}

//struct seoView_Previews: PreviewProvider {
//    static var previews: some View {
//        seoView()
//    }
//}
