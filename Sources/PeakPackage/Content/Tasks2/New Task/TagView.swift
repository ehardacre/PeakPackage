//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 5/27/21.
//

import Foundation
import SwiftUI

class TagManager : Manager {
    
    @Published var tags : [Tag] = []
    @Published var selectionManager = SelectionManager()
    
    @State var tempTabs = ["Hootsuite","Google Ads","Chem-Drys","NHance"]
    
    func loadTags(){
        printr("loading tags")
        for tabName in tempTabs {
            let newTab = Tag(name: tabName, franchiseList: "1,2,3")
            tags.append(newTab)
        }
    }
    
}

struct Tag : View {
    
    var id = UUID()
    var name : String
    var franchiseList : String
    @State var selected = false
    
    var body : some View {
    
        HStack{
            Text(name)
                .bold()
                .foregroundColor(selected ? Color.lightAccent : Color.darkAccent)
        }
        .padding(8)
        .background(Capsule().stroke(selected ? Color.clear : Color.darkAccent, lineWidth: 4))
        .background(selected ? Color.main : Color.clear)
        .clipShape(Capsule())
//        .simultaneousGesture(TapGesture().onEnded({
//            selected.toggle()
//        }))
        
    }
    
    func select() {
        selected.toggle()
    }
    
    func getFranchiseIds() -> [String]{
        printr("getting franchise ids")
        return franchiseList.components(separatedBy: ",")
    }
}

struct TagView : View {
    
    @State var manager : TagManager
    @State var franchiseSelectionManager : FranchiseSelectionManager
    @State var tags: [Tag]

    var body : some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(tags, id: \.id){
                    tag in
                    tag.highPriorityGesture(TapGesture().onEnded({
                        _ in
                        tag.select()
                        printr("tapping tag")
                    }))
                }
            }
        }
    }
}

