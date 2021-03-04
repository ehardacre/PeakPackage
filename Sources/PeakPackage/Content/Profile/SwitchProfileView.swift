//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/25/21.
//

import SwiftUI

struct SwitchProfileView: View {
    
    @State var profiles : [Franchise]
    @ObservedObject var profileManager : ProfileManager
    
    var body: some View {
        VStack{
            Text("Switch Profiles").bold().foregroundColor(Color.darkAccent)
            List(){
                ForEach(profiles, id: \.franchiseId){ profile in
                    profileRow(franchise: profile, manager: profileManager)
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
        .background(manager.id == self.franchise.franchiseId ? Color.main : Color.clear)
        .foregroundColor(manager.id == self.franchise.franchiseId ? Color.lightAccent : Color.darkAccent)
        .onTapGesture(count: 1, perform: {
            manager.changeFranchise(to: franchise.franchiseId, newURL: franchise.franchiseURL)
        })
    }
}
