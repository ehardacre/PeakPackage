//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/19/21.
//

import Foundation
import SwiftUI

struct TaskListView: View {
    
    @ObservedObject var selectionManager = SelectionManager()
    
    @State var completeListOpen = false
    
    var taskManager : TaskManager2
    var completedTasks : [TaskCardView] = []
    var openTasks : [TaskCardView] = []
    
    init(
        taskManager: TaskManager2,
        completedTasks : [Task],
        openTasks : [Task]){
        self.taskManager = taskManager
        self.completedTasks = taskManager.convert(
            tasks: completedTasks,
            selectionManager: selectionManager)
        self.openTasks = taskManager.convert(
            tasks: openTasks,
            selectionManager: selectionManager)
    }
    
    var body: some View {
        List{
            //COmpleted Tasks
            Text("Completed")
                .SectionTitle()
            if completedTasks.count > 0 {
                if !completeListOpen {
                    completedTasks.first!
                } else {
                    ForEach(completedTasks.prefix(10), id: \.id){
                        task in
                        task
                    }
                }
                Button(action: {
                    completeListOpen.toggle()
                }, label: {
                    Text(completeListOpen ? "See Less" : "See More")
                        .ButtonText()
                })
                .RoundRectButton()
            } else {
                Text("No Completed Tasks")
                    .Caption()
            }
            //Open Tasks
            Text("Open")
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
        .CleanList()
    }
}

struct TaskListView_Preview : PreviewProvider {
    static var previews: some View{
        TaskListView(
            taskManager: TaskManager2(),
            completedTasks: TaskManager2.generateCompleteTasks(num: 3),
            openTasks: TaskManager2.generateOpenTasks(num: 10))
    }
}

