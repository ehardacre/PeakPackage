//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI



struct TaskInfoView: View {
    
    var task : Task
    var infos : [TaskField]
    @State var taskState = 0
    
    init(task: Task) {
        self.task = task
        infos = TaskManager2.parseRequest(task.request)
    }
    
    var body: some View {
        VStack{
            Group{
                Text(task.type == "user_requested" ?
                        "Requested" : "Complimentary")
                Text(TaskManager2.cleanDate(task.date))
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
            TaskStateManagerView(selection: $taskState).onAppear{
                switch task.status{
                case "2": //open
                    taskState = 0
                case "5": //complete
                    taskState = 2
                default:
                    taskState = 1
                }
            }
        }
    }
}

struct TaskInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInfoView(task: Task(id: "1", request: "(Service Page Addition for admin) Details include [Service Title: Test Service] [Custom Content: Testing new Teams update]", date: "2021-03-23 12:00:00", status: "open", type: "user_requested"))
    }
}
