//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 4/29/21.
//

import Foundation
import SwiftUI

class CalendarSelectionManager : ObservableObject{
    
    @Published var selection : Date? = nil
    
    func selectDate(_ date: Date?){
        selection = date
        NotificationCenter.default.post(Notification(name: Notification.Name("DateSelectionChange")))
    }
}

struct CalendarView2: View {
    
    @State var taskManager : TaskManager2
    @State var selectedMonth = 1
    @State var selectionMan = CalendarSelectionManager()
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                TabView(selection: $selectedMonth) {
                    MonthView2(selectionMan: selectionMan, month: .last)
                        .tag(0)
                    MonthView2(selectionMan: selectionMan, month: .current)
                        .tag(1)
                    MonthView2(selectionMan: selectionMan, month: .next)
                        .tag(2)
                }
                .frame(width: geo.size.width)
                .tabViewStyle(PageTabViewStyle())
            }
            
            TaskListView(taskManager: taskManager,
                         completedTasks: taskManager.completedTasks,
                         openTasks: taskManager.openTasks)
            
        }
        .padding(0)
    }
}


