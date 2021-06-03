//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 6/3/21.
//

import Foundation
import SwiftUI

struct TaskAssignmentView: View {
    
    @Binding var selection : Int
    @State var users : [adminProfiles]
    //let pickerOptions = ["Quince","Tom","Ethan"]
    
    var body: some View {
        Picker(
            selection: $selection,
            label: Text(""),
            content: {
            //display each of the duration choices
            ForEach(0 ..< users.count){
                i in
                Text(self.users[i].name)
                    .foregroundColor(Color.darkAccent)
            }
        })
            .pickerStyle(SegmentedPickerStyle())
            .frame(height: 50)
            .padding(.horizontal, 30)
    }
}

struct TaskAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskStateManagerView(selection: .constant(0))
    }
}
