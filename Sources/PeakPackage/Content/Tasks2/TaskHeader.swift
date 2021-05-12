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
                .navigationBarTitle("Tasks")
                .navigationBarItems(
                    trailing: Button(action: {
                        makingNewTask = true
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.darkAccent)
                    }).TrailingButton()
                )
        }
        .stackOnlyNavigationView()
        .sheet(
            isPresented: $makingNewTask,
            content: {
                NewTaskPage(taskManager: taskManager, forms: taskManager.forms)
        })
    }
}

struct TaskHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TaskHeaderView(taskManager: TaskManager2())
    }
}
