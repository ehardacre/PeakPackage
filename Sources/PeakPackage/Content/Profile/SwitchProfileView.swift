//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/25/21.
//

import SwiftUI

class ProfileSelectionManager: ObservableObject {
    @Published var id : String?
}

struct SwitchProfileView: View {
    
    @State var profiles : [Franchise]
    @ObservedObject var selectionManager = ProfileSelectionManager()
    
    var body: some View {
        VStack{
            Text("Switch Profiles").bold().foregroundColor(Color.darkAccent)
            List(){
                ForEach(profiles, id: \.franchiseId){ profile in
                    profileRow(franchise: profile, selectionManager: selectionManager)
                }
            }
        }
    }
}

struct profileRow: View {
    
    @State var franchise : Franchise
    @State var selectionManager : ProfileSelectionManager
    
    let selectionIDKey = "selectionIdProfile"
    
    var body: some View{
        HStack{
            Text(franchise.franchiseTitle).padding().onAppear{
                checkForSelection()
            }
            Spacer()
        }
        .background(self.franchise.franchiseId == self.selectionManager.id ? Color.main : Color.clear)
        .foregroundColor(self.franchise.franchiseId == self.selectionManager.id ? Color.lightAccent : Color.darkAccent)
        .onTapGesture(count: 1, perform: {
            if self.franchise.franchiseId == self.selectionManager.id {
                self.selectionManager.id = nil
            }else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.selectionManager.id = self.franchise.franchiseId
                defaults.setTempFranchiseURL(self.franchise.franchiseURL)
                UserDefaults.standard.set(self.franchise.franchiseId, forKey: selectionIDKey)
            }
        })
    }
    
    func checkForSelection(){
        if UserDefaults.standard.string(forKey: selectionIDKey) == self.franchise.franchiseId{
            self.selectionManager.id = self.franchise.franchiseId
        }
    }
}
