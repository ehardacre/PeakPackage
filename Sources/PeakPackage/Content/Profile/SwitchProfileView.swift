//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/25/21.
//

import SwiftUI

struct SwitchProfileView: View {
    
    @State var profiles : [Franchise]
    @ObservedObject var selectionManager = SelectionManager()
    
    var body: some View {
        List(){
            ForEach(profiles, id: \.franchiseId){ profile in
                profileRow(franchise: profile, selectionManager: selectionManager)
            }
        }
    }
}

struct profileRow: View {
    
    var id = UUID()
    @State var franchise : Franchise
    @State var selectionManager : SelectionManager
    @State var selected = false
    
    var body: some View{
        HStack{
            Text(franchise.franchiseTitle)
            Spacer()
        }
        .border(self.selected ? Color.main : Color.clear)
        .onTapGesture(count: 1, perform: {
            if self.id == self.selectionManager.id {
                self.selectionManager.id = nil
            }else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.selectionManager.id = self.id
                self.selected = true
                defaults.setFranchiseURL(self.franchise.franchiseURL)
            }
        })
    }
}
