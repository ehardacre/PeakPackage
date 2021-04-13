//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/26/21.
//

import Foundation
import SwiftUI

struct seoCardView: View {
    
    private let upSymbol = "arrow.up.circle.fill"
    private let downSymbol = "arrow.down.circle.fill"
    private let noChange = "circle.fill"
    //height of the row
    var height : CGFloat = 120
    
    //needs an id as an identifier for list
    var id = UUID()
    @ObservedObject var selectionManager : SelectionManager
    @ObservedObject var manager : SEOManager
    @State var rank : viewableSearchResult
    @State var showMoreInfo = false
    @State var organicUp = false
    @State var mapsUp = false
    
    var body: some View {
        //UI elements
        GeometryReader{
            geo in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.lightAccent)
                .frame(height: self.height)
                .overlay(
                    HStack{
                        GeometryReader{
                            smallGeo in
                        //displaying the content on the card
                            VStack(alignment: .leading) {
                                Spacer()
                                Text(rank.term)
                                    .font(.headline)
                                    .foregroundColor(.main)
                                    .underline()
                                    .padding(.top, 10)
                                    .padding(.bottom, 20)
                                    .padding(.leading, 20)
                                HStack(spacing: 0){
                                    HStack{
                                        Spacer()
                                        if rank.change == nil {
                                            Image(
                                                systemName: noChange)
                                                .imageScale(.large)
                                                .foregroundColor(Color.darkAccent)
                                                .opacity(0.2)
                                        } else if rank.change! {
                                            Image(systemName: downSymbol)
                                                .imageScale(.large)
                                                .foregroundColor(Color.red)
                                        } else {
                                            Image(systemName: upSymbol)
                                                .imageScale(.large)
                                                .foregroundColor(Color.green).onAppear{
                                                    organicUp = true
                                                }
                                        }
                                        Text(rank.organic_rank == "-1" ? "-" : rank.organic_rank)
                                            .font(.footnote)
                                            .bold()
                                            .foregroundColor(Color.darkAccent)
                                        Text("Organic Rank")
                                            .font(.footnote)
                                            .foregroundColor(Color.darkAccent)
                                        Spacer()
                                    }
                                    .background((organicUp ? Color.main : Color.lightAccent).frame(width: smallGeo.size.width/2 ,height: smallGeo.size.height/2))
                                    .edgesIgnoringSafeArea(.bottom)
                                    
                                    
                                    HStack{
                                        Spacer()
                                        if rank.change_maps == nil {
                                            Image(systemName: noChange)
                                                .imageScale(.large)
                                                .foregroundColor(Color.darkAccent)
                                                .opacity(0.2)
                                        } else if rank.change_maps! {
                                            Image(systemName: upSymbol)
                                                .imageScale(.large)
                                                .foregroundColor(Color.green)
                                        } else {
                                            Image(systemName: downSymbol)
                                                .imageScale(.large)
                                                .foregroundColor(Color.red)
                                        }
                                        Text(rank.maps_rank == "-1" ? "-" : rank.maps_rank)
                                            .font(.footnote)
                                            .bold()
                                            .foregroundColor(Color.darkAccent)
                                        Text("Maps Rank")
                                            .font(.footnote)
                                            .foregroundColor(Color.darkAccent)
                                        Spacer()
                                    }
//                                    .background((mapsUp ? Color.main : Color.lightAccent).frame(width: smallGeo.size.width/2 ,height: smallGeo.size.height/2))
                                    .edgesIgnoringSafeArea(.bottom)
                                }
                                Spacer()
                            }
                        Spacer()
                        }
                    }
                    .frame(width: geo.size.width, height: self.height)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                (self.id == self.selectionManager.id) ?
                                    Color.blue : Color.mid,
                                lineWidth:
                                    (self.id == self.selectionManager.id)
                                    ? 3 : 1))
                        )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture(
                        count: 1,
                        perform: {
                        if self.id == self.selectionManager.id {
                            self.selectionManager.id = nil
                        }else{
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            self.selectionManager.id = self.id
                            self.showMoreInfo = true
                        }
                    })
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .sheet(
                isPresented: self.$showMoreInfo,
                content: {
                    seoInfoView(
                        manager: manager,
                        searchTerm: rank.term)
            })
    }
}

struct seoCardView_Preview: PreviewProvider{
    
    static var previews : some View{
        seoCardView(selectionManager: SelectionManager(), manager: SEOManager(), rank: viewableSearchResult(term: "Cabinet Refinishing", organic_rank: "2", maps_rank: "5"))
    }
}
