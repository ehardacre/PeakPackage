//
//  Task.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 8/27/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation

/**
 # Task
 is used to hold the information about a task in the request page view
 
 * taskId - the id of the task in the DB
 * request - the details of the request
 * date - the date of creation
 * status - 2 = queued, 5 = complete
 * type - "user_requested" means that the user requested this task from the app or from the website
 */
struct Task: Codable{
    var taskId: String
    var request: String
    var date: String
    var status: String
    var type: String
}

extension Task {
    init(
        id: String,
        request: String,
        date: String,
        status: String,
        type: String){
        self.taskId = id
        self.request = request
        self.date = date
        self.status = status
        self.type = type
    }
}

/**
# Task Type
This is used to label the type of the task

TODO:  Eventually this needs to contain the types: user_requested, complimentary, open and closed
TODO: this could also be moved into the definition for a task
*/
struct TaskType{
    var status : TaskStatus = TaskStatus.noStatus
    var origin : TaskOrigin = TaskOrigin.noOrigin
}

/**
 # Task Status
 Used to hold the possible values of a tasks status such as open, complete, any or none
 */
enum TaskStatus : String{
    case open = "2"
    case inProgress = "3"
    case complete = "5"
    case noStatus
    case anyStatus
}

/**
 # Task Origin
 Used to describe where a task originated such as by user request or a complementary service of peak studios
 */
enum TaskOrigin : String{
    case userRequested = "user_requested"
    case complementary = "Complimentary"
    case noOrigin
    case anyOrigin
}


extension Task {
    /**
     #Get Type
        returns the type of the task including the status and origin 
     */
    func getType() -> TaskType{
        var stat = TaskStatus.complete
        var orig = TaskOrigin.complementary
        if status == TaskStatus.open.rawValue {
            stat = TaskStatus.open
        }else if status != TaskStatus.complete.rawValue {
            stat = TaskStatus.inProgress
        }
        if type.contains(TaskOrigin.userRequested.rawValue) {
            orig = TaskOrigin.userRequested
        }
        return TaskType(status: stat, origin: orig)
    }
    
    /**
     #Convert to Calendar Card
     */
    func convertToCalendarCard(with selectionManager: SelectionManager, and taskManager: TaskManager2) -> TaskCalendarCardView{
        
        var request = self.request
        var franchise = defaults.franchiseName() ?? ""
        
        let end = request.firstIndex(of: "]")
        let start = request.firstIndex(of: "[")
        
        if end != nil && start != nil {
            
            request = String(request[(start ?? request.startIndex) ... (end ?? request.endIndex)])
            request = request
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: "[", with: "")
            let info = request.split(separator: ":")
            
            if info.count > 1{
                
                request = String(info[0])
                
                if defaults.admin {
                    franchise = String(info[1])
                }
                
            }
            
        }
        
        request = request + " for " + franchise
        
        let type = self.getType()
        //create the card view
        return TaskCalendarCardView(
            selectionManager: selectionManager,
            taskManager: taskManager,
            task: self,
            type: type,
            date: TaskManager2.cleanDate(self.date),
            content: request )
        
    }
    
    /**
     #Convert To Card
     - Returns: (TaskCardView) returns a view for a task card corresponding to the task (self)
     */
    func convertToCard(with selectionManager: SelectionManager, and taskManager: TaskManager2) -> TaskCardView2{
        //the request
        
        var request = self.request
        var franchise = defaults.franchiseName() ?? ""
        
        let end = request.firstIndex(of: "]")
        let start = request.firstIndex(of: "[")
        
        if end != nil && start != nil {
            
            request = String(request[(start ?? request.startIndex) ... (end ?? request.endIndex)])
            request = request
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: "[", with: "")
            let info = request.split(separator: ":")
            
            if info.count > 1{
                
                request = String(info[0])
                
                if defaults.admin {
                    franchise = String(info[1])
                }
                
            }
            
        }
        
        request = request + " for " + franchise
        
        let type = self.getType()
        //create the card view
        return TaskCardView2(
            selectionManager: selectionManager,
            taskManager: taskManager,
            task: self,
            type: type,
            date: TaskManager2.cleanDate(self.date),
            content: request )
    }
    
    
}
