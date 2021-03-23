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
    
    init(task: Task) {
        self.task = task
        infos = TaskManager2.parseRequest(task.request)
    }
    
    var body: some View {
        VStack{
            Text(task.type == "user_requested" ? "Requested" : "Complimentary")
            Text(TaskManager2.cleanDate(task.date))
            Divider().frame(width: 250)
            ForEach(infos, id: \.id){
                info in
                Text(info.title)
                Text(info.value)
            }
        }
    }
}

struct TaskInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInfoView(task: Task(id: "1", request: "(Service Page Addition for admin) Details include [Service Title: Test Service] [Custom Content: Testing new Teams update]", date: "2021-03-23 12:00:00", status: "open", type: "user_requested"))
    }
}
