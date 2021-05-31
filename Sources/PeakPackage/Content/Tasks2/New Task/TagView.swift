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
            let newTab = Tag(selectionManager: selectionManager, name: tabName, franchiseList: "")
            tags.append(newTab)
        }
    }
    
}

struct Tag {
    
    var id = UUID()
    @State var selectionManager : SelectionManager
    var name : String
    var franchiseList : String
    
    var display : some View {
    
        HStack{
            Text(name)
                .foregroundColor(selectionManager.id == id ? Color.lightAccent : Color.darkAccent)
        }
        .padding(5)
        .background(selectionManager.id == id ? Color.main : Color.clear)
        .background(selectionManager.id == id ? Capsule().strokeBorder(Color.clear, lineWidth: 2) : Capsule().strokeBorder(Color.darkAccent, lineWidth: 2))
        .clipShape(Capsule())
        .onTapGesture {
            selectionManager.id = id
        }
        
    }
    
    func getFranchiseIds() -> [String]{
        return franchiseList.components(separatedBy: ",")
    }
}

struct TagView : View {
    
    @State var manager : TagManager
    @State var tags: [Tag]

    var body : some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(tags, id: \.id){
                    tag in
                    tag.display
                }
            }
        }
    }
}

