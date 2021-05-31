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
        DatabaseDelegate.getFranchiseGroupTags(completion: {
            rex in
            var dbtags = rex as! [franchiseGroupTag]
            self.tags = dbtags.map({$0.toTagforView()})
        })
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
        .highPriorityGesture(TapGesture().onEnded({
            selected.toggle()
        }))
        
    }
    
    func getFranchiseIds() -> [String]{
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
                    tag.simultaneousGesture(TapGesture().onEnded({
                        _ in
                        for id in tag.getFranchiseIds() {
                            franchiseSelectionManager.selectFranchise(id: id)
                        }
                    }))
                }
            }
        }
    }
}

