//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI

struct TaskHeaderView: View {
    
    var taskManager : TaskManager2
    @State var makingNewTask = false
    
    var body: some View {
        NavigationView{
            TaskListView(taskManager: taskManager, completedTasks: taskManager.completedTasks, openTasks: taskManager.openTasks)
        }
        .navigationBarTitle("Tasks")
        .navigationBarItems(
            trailing: Button(action: {
                
            }, label: {
                Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                    .foregroundColor(Color.darkAccent)
            }))
    }
}

struct TaskHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TaskHeaderView(taskManager: TaskManager2())
    }
}
