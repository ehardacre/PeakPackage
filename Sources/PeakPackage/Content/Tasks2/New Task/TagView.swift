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
            let newTab = Tag(name: tabName, franchiseList: "")
            tags.append(newTab)
        }
    }
    
}

struct Tag {
    
    var id = UUID()
    var name : String
    var franchiseList : String
    @State var selected = false
    
    var display : some View {
    
        HStack{
            Text(name)
                .bold()
                .foregroundColor(selected ? Color.lightAccent : Color.darkAccent)
        }
        .padding(5)
        .onTapGesture {
            printr(id)
            selected.toggle()
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

