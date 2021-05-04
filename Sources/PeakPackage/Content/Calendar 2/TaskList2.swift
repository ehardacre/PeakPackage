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
    @State var completedTasks : [TaskCalendarCardView] = []
    @State var openTasks : [TaskCalendarCardView] = []
    
    init(
        taskManager: TaskManager2,
        completedTasks : [Task],
        openTasks : [Task]){
        self.taskManager = taskManager
        self.completedTasks = taskManager.convertForCalendar(
            tasks: completedTasks,
            selectionManager: selectionManager,
            taskManager: taskManager)
        self.openTasks = taskManager.convertForCalendar(
            tasks: openTasks,
            selectionManager: selectionManager,
            taskManager: taskManager)
    }
    
    var body: some View {
        List{
            //COmpleted Tasks
            ForEach(completedTasks, id: \.id){
                task in
                task
            }
            
            //Open Tasks
            Text("In Progress")
                .SectionTitle()
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
            printr("changing tasks")
            printr(date)
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
        })
    }
}

