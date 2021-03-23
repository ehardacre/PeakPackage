//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI

struct TaskStateManagerView: View {
    
    @Binding var selection : Int
    let pickerOptions = ["seal","seal.fill","checkmark.seal.fill"]
    let pickerColors = [Color.darkAccent, Color.darkAccent, Color.main]
    
    var body: some View {
        Picker(
            selection: $selection,
            label: Text(""),
            content: {
            //display each of the duration choices
            ForEach(0 ..< pickerOptions.count){
                i in
                Image(systemName: self.pickerOptions[i])
                    .foregroundColor(self.pickerColors[i])
                    .imageScale(.large)
               // Text(self.pickerOptions[i])
            }
        })
            .pickerStyle(SegmentedPickerStyle())
            .frame(height: 50)
            .padding(.horizontal, 30)
    }
}

struct TaskStateManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TaskStateManagerView(selection: .constant(0))
    }
}
