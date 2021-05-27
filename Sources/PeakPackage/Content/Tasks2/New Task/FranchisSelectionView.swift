//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/25/21.
//

import Foundation
import SwiftUI

struct FranchiseSelectionView: View {
    
    @State var profiles : [Franchise]
    @State var profileManager : FranchiseSelectionManager
    @State var searchedProfiles : [Franchise] = []
    @State var searching = false
    
    @State var tempTabs = ["Social Posts","Ads Budget"]
    
    var body: some View {
        VStack{
            Text("Select Franchises For Task")
                .bold()
                .foregroundColor(Color.darkAccent)
            ProfileSearchBar(
                searching: $searching,
                mainList: $profiles,
                searchedList: $searchedProfiles)
            .onAppear{
                searchedProfiles = profiles
            }
            .zIndex(10)
            List(){
                ForEach(
                    searchedProfiles,
                    id: \.franchiseId){
                    profile in
                    profileRow_Task(
                        franchise: profile,
                        manager: profileManager,
                        selected: profileManager.ids.contains(profile.franchiseId))
                }
            }
            .padding(.top, -15)
            
            LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]){
                ForEach(tempTabs, id:\.self){
                    tab in
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Spacer()
                            Text(tab)
                                .padding(10)
                                .foregroundColor(Color.main)
                            Spacer()
                        }
                        
                    })
                    .background(Capsule().strokeBorder(Color.main, lineWidth: 2.0))
                }
            }
        }
    }
}

struct profileRow_Task: View {
    
    let selectionIDKey = "selectionIdProfile"
    
    @State var franchise : Franchise
    @State var manager : FranchiseSelectionManager
    @State var selected = false
    
    var body: some View{
        HStack{
            Text(franchise.franchiseTitle)
                .padding()
            Spacer()
        }
        .cornerRadius(10)
        .background(selected ? Color.main : Color.clear)
        .foregroundColor(selected ? Color.lightAccent : Color.darkAccent)
        .onTapGesture(
            count: 1,
            perform: {
                manager.selectFranchise(id: franchise.franchiseId)
        })
        .onReceive(
            NotificationCenter.default.publisher(
                for: Notification.Name(rawValue: "franchiseForTaskUpdated"))
        ){
            _ in
            if manager.isSelectedFranchise(id: franchise.franchiseId){
                selected = true
            }else{
                selected = false
            }
        }
    }
}
