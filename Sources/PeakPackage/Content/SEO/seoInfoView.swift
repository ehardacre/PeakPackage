//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/2/21.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct seoInfoView : View {
    
    @ObservedObject var manager : SEOManager
    @State var searchTerm : String
    
    var body : some View{
        VStack{
            
            Text(searchTerm).bold().font(.title3).padding(20)
            List{
                ForEach(manager.weekbyweek(for: searchTerm), id: \.id){ week in
                    pastSeoCardView(week: week.term, organicRank: week.organic_rank, mapsRank: week.maps_rank)
                }.listRowBackground(Color.clear)
            }
        }
    }
}


struct pastSeoCardView: View {
    
    //needs an id as an identifier for list
    var id = UUID()
    
    //height of the row
    var height : CGFloat = 50

    @State var week : String
    @State var organicRank : String
    @State var mapsRank : String
    
    var body: some View {
        
        
        HStack{
            
            Image(systemName: "\(week).square.fill").foregroundColor(Color.darkAccent).imageScale(.large)
            
            Spacer()
            
            VStack{
                Text("Organic")
                    .font(.footnote)
                    .foregroundColor(.darkAccent)
                Text(organicRank)
                    .bold()
                    .foregroundColor(.darkAccent)
                    .padding(20)
            }
            .padding(20)
            .background(Color.lightAccent)
            .cornerRadius(20)
            
            Spacer()
            
            VStack{
                Text("Maps")
                    .font(.footnote)
                    .foregroundColor(.darkAccent)
                Text(mapsRank)
                    .bold()
                    .foregroundColor(.darkAccent)
                    .padding(20)
            }
            .padding(20)
            .background(Color.lightAccent)
            .cornerRadius(20)
            
            Spacer()
        }
        .background(Color.clear)
        .padding(.horizontal,50)
        .padding(.vertical, 10)
            
    
    }
}

struct pastSeoCardView_Preview : PreviewProvider {
    
    static var previews: some View{
        
        pastSeoCardView(week: "12", organicRank: "3", mapsRank: "2")
        
    }
    
}


