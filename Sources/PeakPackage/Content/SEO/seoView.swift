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
        seoView()
    }
    
}

struct seoView: View {
    var body: some View {
        NavigationView{
            List{
                HStack{
                    Text("Search Term").bold().font(.footnote).foregroundColor(.darkAccent).opacity(0.5)
                    Spacer()
                    Text("Rank").font(.footnote).foregroundColor(.darkAccent).opacity(0.5)
                }
                HStack{
                    Text("Cabinet Refinishing")
                    Spacer()
                    Text("10")
                    Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                }
                
                HStack{
                    Text("NHance")
                    Spacer()
                    Text("5")
                    Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("SEO Rankings")
        }
    }
}

struct seoView_Previews: PreviewProvider {
    static var previews: some View {
        seoView()
    }
}
