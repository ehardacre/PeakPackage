//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/17/21.
//

import SwiftUI

struct Content_Tasks: PublicFacingContent {

    @ObservedObject public var manager : Manager
    @State public var taskIndex = 0

    init(manager: Manager) {
        self.manager = manager
    }
    
    var body: some View {
        ZStack{
            //Only the admin users can view in progress tasks
            
            switch taskIndex{
            
            case 0:
                RequestPageView(taskMan: (manager as! TaskManager), tasklist: (manager as! TaskManager).openTasks, status: TaskStatus.open)
            case 1:
                RequestPageView(taskMan: (manager as! TaskManager), tasklist: (manager as! TaskManager).completeTasks, status: TaskStatus.complete)
            default:
                EmptyView()
            }
        
//                .onAppear{
//                    if self.tab == tabs.tasks {
//                        self.taskIndex = 1
//                    }
//                    self.taskManager.loadTasks()
//                }
    
            
            
            VStack{
                Spacer()
                if defaults.admin {
                    PageControl(index: $taskIndex, maxIndex: 1, pageNames: ["Requested","Completed"])
                }else{
                    PageControl(index: $taskIndex, maxIndex: 1, pageNames: ["Requested","Completed"])
                }
            }
        }
    }
}
