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
    @State var searchedProfiles : [Franchise] = []
    @State var searching = false
    
    var body: some View {
        VStack{
            Text("Switch Profiles")
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
                    profileRow(
                        franchise: profile,
                        manager: profileManager,
                        selected: profileManager.id == profile.franchiseId)
                }
            }
            .padding(.top, -15)
        }
    }
}

struct profileRow: View {
    
    let selectionIDKey = "selectionIdProfile"
    
    @State var franchise : Franchise
    @State var manager : ProfileManager
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
            manager.changeFranchise(
                to: franchise.franchiseId,
                newURL: franchise.franchiseURL,
                newName: franchise.franchiseTitle)
        })
        .onReceive(
            NotificationCenter.default.publisher(
                for: LocalNotificationManager.postNamefor(type: .changed, subject: LocalNoteSubjects.profile.rawValue))
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

struct ProfileSearchBar: View {
    
    @State private var searchInput: String = ""
    @Binding var searching: Bool
    @Binding var mainList: [Franchise]
    @Binding var searchedList: [Franchise]

    var body: some View {
        ZStack {
            // Background Color
            Color.main.cornerRadius(8.0)
            // Custom Search Bar (Search Bar + 'Cancel' Button)
            HStack {
                // Search Bar
                HStack {
                    // Magnifying Glass Icon
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.lightAccent)

                    // Search Area TextField
                    TextField("", text: $searchInput)
                        .onChange(of: searchInput, perform: {
                            searchText in
                            searching = true
                            searchedList = mainList.filter {
                                $0.franchiseTitle.lowercased()
                                .prefix(searchText.count) ==
                                searchText.lowercased() ||
                                $0.franchiseTitle.lowercased()
                                .contains(searchText.lowercased()) }
                        })
                        .accentColor(.darkAccent)
                        .foregroundColor(.darkAccent)
                }
                .padding(EdgeInsets(top: 5,
                                    leading: 10,
                                    bottom: 5,
                                    trailing: 5))
                .background(Color.lightAccent.opacity(0.5))
                .cornerRadius(8.0)
                // 'Cancel' Button
                Button(action: {
                    searching = false
                    searchInput = ""
                    // Hide Keyboard
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil)
                }, label: {
                    Text("Cancel")
                        .foregroundColor(Color.lightAccent)
                })
                .accentColor(Color.lightAccent)
                .padding(EdgeInsets(top: 2,
                                    leading: 2,
                                    bottom: 2,
                                    trailing: 8))
            }
            .padding(EdgeInsets(top: 5,
                                leading: 5,
                                bottom: 5,
                                trailing: 5))
        }
        .frame(height: 50)
    }
}
