//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI



struct TaskInfoView: View {
    
    @State var manager : TaskManager2
    var task : Task
    var infos : [TaskField]
    @State var taskState = 0
    @State var taskAssignment = 0
    @State var prevTaskState = 0
    @State var prevTaskAssignment = 0
    let taskStatuses = [TaskStatus.open, TaskStatus.inProgress, TaskStatus.complete]
    
    init(manager: TaskManager2, task: Task) {
        self.task = task
        _manager = State(initialValue: manager)
        infos = TaskManager2.parseRequest(task.request)
    }
    
    var body: some View {
        VStack{
            Group{
                if taskState == 0 { // not completed
                    Text(task.type == "user_requested" ?
                            "Requested" : "Complimentary")
                        .CardTitle()
                        .padding(.top, 20)
                }else if taskState == 2 { //completed
                    Text("Completed")
                        .CardTitle()
                        .padding(.top, 20)
                } else{ //in progress
                    Text("Started")
                        .CardTitle()
                        .padding(.top, 20)
                }
                Text(TaskManager2.cleanDate(task.date))
                    .Caption()
                Divider()
                    .frame(width: 250)
            }
            Spacer()
            ForEach(infos, id: \.id){
                info in
                Text(info.title)
                    .CardTitle()
                Text(info.value)
                    .Caption()
                    .padding(.bottom, 10)
            }
            Spacer()
            if defaults.admin {
                TaskAssignmentView(selection: $taskAssignment, users: manager.adminUsers)
                    .onAppear{
                        for i in 0..<manager.adminUsers.count {
                            if manager.adminUsers[i].id == task.assignment{
                                taskAssignment = i
                                prevTaskAssignment = i
                            }
                        }
                    }
                    .onDisappear{
                        if taskAssignment != prevTaskAssignment {
                            DatabaseDelegate.updateTask(taskId: task.taskId, taskStatus: taskStatuses[taskState], taskAssignment: String(taskAssignment), completion: {
                                _ in
                                manager.reloadTasks()
                            })
                        }
                    }
                TaskStateManagerView(selection: $taskState)
                    .onAppear{
                        switch task.status{
                        case "2": //open
                            taskState = 0
                            prevTaskState = 0
                        case "5": //complete
                            taskState = 2
                            prevTaskState = 2
                        default:
                            taskState = 1
                            prevTaskState = 1
                        }
                }
                    .onDisappear{
                        if taskState != prevTaskState {
                            DatabaseDelegate.updateTask(taskId: task.taskId, taskStatus: taskStatuses[taskState], taskAssignment: String(taskAssignment), completion: {
                                _ in
                                manager.reloadTasks()
                            })
                        }
                    }
            }
        }
    }
}
