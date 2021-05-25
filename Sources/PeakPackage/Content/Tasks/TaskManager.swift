//
//  TaskManager.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 8/26/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

//import Foundation
//import SwiftUI
//
//public class TaskManager : Manager {
//
//    @Published var tasks = [Task]()
//    //status based lists
//    @Published var openTasks = [Task]()
//    @Published var inProgressTasks = [Task]()
//    @Published var completeTasks = [Task]()
//    //origin based lists
//    @Published var userTasks = [Task]()
//    @Published var complementaryTasks = [Task]()
//    //status and origin based lists
//    @Published var completeComplementaryTasks = [Task]()
//
//    static var taskTypes = [TaskStatus.open , TaskStatus.complete]
//    static var adminTaskTypes = ["Open Tasks", "Complete"]
//
//    public override init(){}
//
//    /**
//    #loadTasks
//     loads all tasks for the signed in user
//    */
//    func loadTasks(){
//        //if tasks has already been populated
//        if !tasks.isEmpty {
//            return
//        }
//        DatabaseDelegate.getTasks(completion: {
//            rex in
//            //set the result to the appropriate tasks
//            self.tasks = self.removeAppts(tasks: rex as! [Task])
//            self.separateTasks()
//        })
//    }
//
//    /**
//     # separate tasks
//        separates the loaded tasks and fills the closed and open tasks arrays
//     */
//    func separateTasks() {
//        for t in tasks{
//            let type = t.getType()
//            //check the status of the task
//            if type.status == TaskStatus.complete {
//                if !self.tasksContains(
//                    taskList: self.completeTasks,
//                    task: t) {
//                    self.completeTasks.append(t)
//                }
//            } else {
//                if !self.tasksContains(
//                    taskList: self.openTasks,
//                    task: t) {
//                    self.openTasks.append(t)
//                }
//            }
//            //check the origin of the task
//            if type.origin == TaskOrigin.userRequested {
//                if !self.tasksContains(
//                    taskList: self.userTasks,
//                    task: t) {
//                    self.userTasks.append(t)
//                }
//            } else {
//                if !self.tasksContains(
//                    taskList: self.complementaryTasks,
//                    task: t) {
//                    self.complementaryTasks.append(t)
//                }
//            }
//            //check status and origin
//            if type.origin == TaskOrigin.complementary &&
//                type.status == TaskStatus.complete {
//                if !self.tasksContains(
//                    taskList: self.completeComplementaryTasks,
//                    task: t) {
//                        self.completeComplementaryTasks.append(t)
//                }
//            }
//        }
//        return
//    }
//
//
//    /**
//    # removeAppts
//    removes all tasks that are actually appointments by looking for the (appt.) lead in
//    */
//    private func removeAppts(tasks: [Task]) -> [Task]{
//
//        //loop through list and remove appointments
//        var taskList : [Task] = []
//        for task in tasks{
//            //TODO: remove the literal for this string
//            if(!task.request.contains("(appt.)")){
//                taskList.append(task)
//            }
//        }
//        return taskList
//    }
//
//    /**
//    # Reset Tasks
//     forces a hard reset on the tasks
//     */
//    func resetTasks(){
//        //get the json for the request
//        let json = JsonFormat.getTasks(id: defaults.franchiseId()!).format()
//        #warning("TODO: move this to dbdelegate file")
//        //perform data base request
//        DatabaseDelegate.performRequest(with: json, ret: returnType.taskList, completion: {
//                rex in
//                //set the result to the appropriate tasks
//                let tempTasks = self.removeAppts(tasks: rex as! [Task])
//                for task in tempTasks{
//                    if !self.tasksContains(taskList: self.tasks, task: task) {
//                        self.tasks.append(task)
//                    }
//                }
//                self.separateTasks()
//                return
//            })
//        return
//    }
//
//    func tasksContains(taskList: [Task], task: Task) -> Bool{
//        for t in taskList{
//            if t.taskId == task.taskId {
//                return true
//            }
//        }
//        return false
//    }
//
//    /**
//    #cleanDate
//     makes the dates given back from the DB more readable
//     as of 07/22/20 the dates are returned as such: yyyy-mm-dd hh:mm:ss
//     this function will return them as mm/dd/yy
//     */
//    static func cleanDate(_ date: String) -> String{
//        var cleanedDate = date
//        let dateEls = (date.split(separator: " ")[0]).split(separator: "-")
//        if dateEls.count >= 3 {
//            let month = dateEls[1]
//            let day = dateEls[2]
//            let year = dateEls[0]
//            let start = year.index(before: year.index(before: year.endIndex))
//            let shortYear = year[start..<year.endIndex]
//            cleanedDate = "\(month)/\(day)/\(shortYear)"
//        }
//        return cleanedDate
//    }
//}
