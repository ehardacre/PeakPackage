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
                #warning("TODO Load forms")
                NewTaskPage(forms: [
                    AutoForm(title: "Add Service Page",
                             subtitle: "A service page added to your website",
                             elements: [
                                AutoFormElement(label: "Service", prompt: "Enter the service you'd like to add", input: "ShortString"),
                                AutoFormElement(label: "Custom Content", prompt: "Enter any custom content", input: "LongString"),
                                AutoFormElement(label: "Integer Input", prompt: "Enter a number", input: "Int"),
                                AutoFormElement(label: "Date Input", prompt: "When will it start?", input: "Date"),
                                AutoFormElement(label: "Multi-Input", prompt: "Pick your choice", input: "Multichoice(choice 1,choice 2, choice 3)")
                            ]),
                    AutoForm(title: "Social Posts",
                             subtitle: "Design and posting of social posts",
                             elements: [])
                ])
        })
    }
}

struct TaskHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TaskHeaderView(taskManager: TaskManager2())
    }
}
