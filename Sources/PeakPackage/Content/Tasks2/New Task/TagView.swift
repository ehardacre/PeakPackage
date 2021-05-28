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
            var newTab = Tag(selectionManager: selectionManager, name: tabName, franchiseList: "")
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
                .foregroundColor(Color.darkAccent)
        }
        .padding(5)
        .background(Capsule().strokeBorder(Color.darkAccent, lineWidth: 2))
        
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
