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
                    profileRow(franchise: profile, selectionManager: profileManager)
                }
            }
        }
    }
}

struct profileRow: View {
    
    @State var franchise : Franchise
    @State var selectionManager : ProfileManager
    @State var selected = false
    
    let selectionIDKey = "selectionIdProfile"
    
    var body: some View{
        HStack{
            Text(franchise.franchiseTitle).padding()
            Spacer()
        }
        .cornerRadius(10)
        .background(selectionManager.id == self.franchise.franchiseId ? Color.main : Color.clear)
        .foregroundColor(selectionManager.id == self.franchise.franchiseId ? Color.lightAccent : Color.darkAccent)
        .onTapGesture(count: 1, perform: {
            if selected {
                self.selectionManager.id = nil
                selected = false
            }else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.selectionManager.id = self.franchise.franchiseId
                selected = true
                defaults.setTempFranchiseURL(self.franchise.franchiseURL)
            }
        })
    }
}
