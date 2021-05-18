//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 5/4/21.
//

import Foundation
import SwiftUI

struct TaskListView2: View {
    
    @ObservedObject var selectionManager = SelectionManager()
    
    @State var completeListOpen = false
    
    var taskManager : TaskManager2
    @State var todaysAppointments : [AppointmentCardView] = []
    @State var completedTasks : [TaskCalendarCardView] = []
    @State var openTasks : [TaskCalendarCardView] = []
    
    @State var temp = false
    
    var body: some View {
        List{
            
            ForEach(todaysAppointments, id: \.id){
                app in
                app
            }
            
            //COmpleted Tasks
            ForEach(completedTasks, id: \.id){
                task in
                task
            }
//            //Open Tasks
//            Text("In Progress")
//                .SectionTitle()
            if openTasks.count > 0 {
                ForEach(openTasks, id: \.id){
                    task in
                    task
                }
            } else {
                Text("No Open Tasks")
                    .Caption()
            }
        }
        .CleanList(rowH: 80)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "DateSelectionChange")), perform: { note in
            var date = (note.object as? Date) ?? Date()
            printr("recieved post for task loading")
            var newCompleted = taskManager.getCompleteTasks(for: date)
            self.completedTasks = taskManager.convertForCalendar(
                tasks: newCompleted,
                selectionManager: selectionManager,
                taskManager: taskManager)
            var newOpen = taskManager.getOpenTasks(for: date)
            self.openTasks = taskManager.convertForCalendar(
                tasks: newOpen,
                selectionManager: selectionManager,
                taskManager: taskManager)
            printr("completed: \(completedTasks.count), open: \(openTasks.count)")
            var newApps = taskManager.getAppointments(for: date)
            self.todaysAppointments = taskManager.convertForCalendar(appointments: newApps, selectionManager: selectionManager, taskManager: taskManager)
        })
        .onAppear{
            printr("posting for task loading")
            NotificationCenter.default.post(Notification(name: Notification.Name("DateSelectionChange"),object: nil))
        }
    }
}

