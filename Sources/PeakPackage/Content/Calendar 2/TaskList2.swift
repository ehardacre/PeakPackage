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
    @State var calSelectionManager : CalendarSelectionManager
    
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
        .onReceive(NotificationCenter.default.publisher(for: LocalNotificationTypes.changedDate.postName()), perform: { note in
            let date = (note.object as? Date) ?? Date()
            let newCompleted = taskManager.getCompleteTasks(for: date)
            self.completedTasks = taskManager.convertForCalendar(
                tasks: newCompleted,
                selectionManager: selectionManager,
                taskManager: taskManager)
            let newOpen = taskManager.getOpenTasks(for: date)
            self.openTasks = taskManager.convertForCalendar(
                tasks: newOpen,
                selectionManager: selectionManager,
                taskManager: taskManager)
            let newApps = taskManager.getAppointments(for: date)
            self.todaysAppointments = taskManager.convertForCalendar(appointments: newApps, selectionManager: selectionManager, taskManager: taskManager)
        })
        .onReceive(updatedTasksPub, perform: {
            note in
            let date = calSelectionManager.selection ?? Date()
            NotificationCenter.default.post(name: LocalNotificationTypes.changedDate.postName(), object: date)
        })
        .onAppear{
            NotificationCenter.default.post(name: LocalNotificationTypes.changedDate.postName(), object: nil)
        }
    }
}

