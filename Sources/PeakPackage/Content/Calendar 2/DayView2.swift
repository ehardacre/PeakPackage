//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 4/29/21.
//

import Foundation
import SwiftUI

struct DayView2 : View {
    
    var id = UUID()
    @State var day : Date?
    @State var today : Bool = false
    @State var selected = false
    @State var selectionMan : CalendarSelectionManager
    
    var body : some View {
        HStack{
            if day == nil{
                Text("")
            }else if today || selected {
                Circle()
                    .foregroundColor(Color.main)
                    .frame(height: 40)
                    .overlay(
                        Text("\(day!.get(.day))")
                            .CardTitle_light()
                    )
                    .onTapGesture {
                        selectionMan.selectDate(nil)
                    }
            }else{
                Circle()
                    .foregroundColor(.clear)
                    .frame(height: 40)
                    .overlay(
                        Text("\(day!.get(.day))")
                            .CardTitle()
                    )
                    .onTapGesture {
                        selectionMan.selectDate(day)
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "DateSelectionChange")), perform: { _ in
            if selectionMan.selection == day {
                selected = true
            }else{
                selected = false
            }
        })
        
    }
}
