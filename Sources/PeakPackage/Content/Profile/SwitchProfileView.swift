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
                    profileRow(franchise: profile, selected: profileManager.id == profile.franchiseId)
                    .onTapGesture(count: 1, perform: {
                        profileManager.changeFranchise(to: profile.franchiseId, newURL: profile.franchiseURL)
                    })
                }
            }
        }
    }
}

struct profileRow: View {
    
    @State var franchise : Franchise
    //@State var manager : ProfileManager
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
    }
}
