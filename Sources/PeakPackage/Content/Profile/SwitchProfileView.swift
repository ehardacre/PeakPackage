//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/25/21.
//

import SwiftUI

struct SwitchProfileView: View {
    
    @State var profiles : [Franchise]
    @State var profileManager : ProfileManager
    
    var body: some View {
        VStack{
            Text("Switch Profiles").bold().foregroundColor(Color.darkAccent)
            List(){
                ForEach(profiles, id: \.franchiseId){ profile in
                    profileRow(franchise: profile, manager: profileManager, selected: profileManager.id == profile.franchiseId)
                }
            }
        }
    }
}

struct profileRow: View {
    
    @State var franchise : Franchise
    @State var manager : ProfileManager
    @State var selected = false
    
    let selectionIDKey = "selectionIdProfile"
    
    var body: some View{
        HStack{
            Text(franchise.franchiseTitle).padding()
            Spacer()
        }
        .cornerRadius(10)
        .background(selected ? Color.main : Color.clear)
        .foregroundColor(selected ? Color.lightAccent : Color.darkAccent)
        .onTapGesture(count: 1, perform: {
            manager.changeFranchise(to: franchise.franchiseId, newURL: franchise.franchiseURL)
        })
        .onReceive(
            NotificationCenter.default.publisher(for: Notification.Name(rawValue: "profileChanged"))
        ){
            note in
            let profile = note.object as! String?
            if profile == nil || profile != franchise.franchiseId{
                selected = false
            }else{
                selected = true
            }
        }
    }
}
