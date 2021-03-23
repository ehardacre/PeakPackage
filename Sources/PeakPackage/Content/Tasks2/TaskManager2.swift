//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/19/21.
//

import Foundation
import SwiftUI

public class TaskManager2 : Manager{
    
    static var taskTypes = [TaskStatus.open , TaskStatus.complete]
    static var adminTaskTypes = ["Open Tasks", "Complete"]
    
    @Published var tasks = [Task]()
    @Published var completedTasks = [Task]()
    @Published var openTasks = [Task]()

    public override init(){}
    
    func loadTasks(){
        if !tasks.isEmpty {
            return
        }
        DatabaseDelegate.getTasks(
            completion: {
                rex in
                self.tasks = self.removeAppts(tasks: rex as! [Task])
                self.sortTasks()
            })
    }
    
    ///sorts the tasks by completed to in progress to open
    func sortTasks(){
        for t in tasks {
            let type = t.getType()
            if type.status == TaskStatus.complete {
                if !tasksContains(
                    taskList: completedTasks,
                    task: t) {
                    completedTasks.append(t)
                }
            } else if type.status == TaskStatus.inProgress {
                if !tasksContains(
                    taskList: openTasks,
                    task: t) {
                    openTasks.insert(t, at: 0)
                }
            } else {
                if !tasksContains(
                    taskList: openTasks,
                    task: t) {
                    openTasks.append(t)
                }
            }
        }
    }
    
    func tasksContains(taskList: [Task], task: Task) -> Bool{
        for t in taskList{
            if t.taskId == task.taskId {
                return true
            }
        }
        return false
    }
    
    /**
    # removeAppts
    removes all tasks that are actually appointments by looking for the (appt.) lead in
    */
    private func removeAppts(tasks: [Task]) -> [Task]{
        
        //loop through list and remove appointments
        var taskList : [Task] = []
        for task in tasks{
            //TODO: remove the literal for this string
            if(!task.request.contains("(appt.)")){
                taskList.append(task)
            }
        }
        return taskList
    }
    
    /**
    #cleanDate
     makes the dates given back from the DB more readable
     as of 07/22/20 the dates are returned as such: yyyy-mm-dd hh:mm:ss
     this function will return them as mm/dd/yy
     */
    static func cleanDate(_ date: String) -> String{
        var cleanedDate = date
        let dateEls = (date.split(separator: " ")[0]).split(separator: "-")
        if dateEls.count >= 3 {
            let month = dateEls[1]
            let day = dateEls[2]
            let year = dateEls[0]
            let start = year.index(before: year.index(before: year.endIndex))
            let shortYear = year[start..<year.endIndex]
            cleanedDate = "\(month)/\(day)/\(shortYear)"
        }
        return cleanedDate
    }
    
    /**
    # Reset Tasks
     forces a hard reset on the tasks
     */
    func resetTasks(){
        DatabaseDelegate.getTasks(
            completion: {
                rex in
                let tempTasks = self.removeAppts(tasks: rex as! [Task])
                for task in tempTasks{
                    if !self.tasksContains(taskList: self.tasks, task: task) {
                        self.tasks.append(task)
                    }
                }
                self.sortTasks()
            })
        
    }
    
    /**
        # convert : converts tasks to views
     - Parameter tasks : the tasks to be converted to task card views
            TODO: make an extension of task
     */
    func convert(tasks: [Task], selectionManager: SelectionManager) -> [TaskCardView2] {
        //empty list of cards
        var cards : [TaskCardView2] = []
        //loop through tasks and individually convert them
        for task in tasks {
            cards.append(task.convertToCard(with: selectionManager))
        }
        return cards.reversed()
    }
    
    static func parseRequest(_ req: String) -> [TaskField]{
        
        var tempDetails : [TaskField] = []
        
        var parts = req.components(separatedBy: "[")
        for part in parts{
            var stripped = part
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: "[", with: "")
            var keyval = stripped.split(separator: ":")
            if keyval.count > 1 {
                let field = TaskField(title: String(keyval[0]), value: String(keyval[1]))
                tempDetails.append(field)
            }
        }
        
        return tempDetails
        
//        printr(req)
//        var tempDetails : [TaskField] = []
////        let regex_title = "\\([^\\(]\\)"
////        let regex_detail = "\\[[^\\[]\\]"
//        let regex_title = "www.[^ ]*.com"
//        let regex_detail = "www.[^ ]*.com"
//        //matches [ ... ] where the string inside doesn't have a new opening bracket
//        do {
//            //TITLE
//            let titleDetector = try NSDataDetector(pattern: regex_title,options: [])
//            let titlematches = titleDetector.matches(
//                in: req,
//                range: NSRange(req.startIndex..., in: req))
//            for match in titlematches {
//                let start = req.index(
//                    req.startIndex,
//                    offsetBy: match.range.lowerBound)
//                let end = req.index(
//                    req.startIndex,
//                    offsetBy: match.range.upperBound)
//                let range = start ..< end
//                let detail = req[range]
//                let info = detail
//                    .replacingOccurrences(of: ")", with: "")
//                    .replacingOccurrences(of: "(", with: "")
//                    .components(separatedBy: "for")
//                if info.count > 1{
//                    let tempType = String(info[0])
//                    let tempFran = String(info[1])
//                    tempDetails.append(TaskField(title: tempType, value: tempFran))
//                }
//            }
//            //DETAILS
//            let detector = try NSDataDetector(pattern: regex_detail)
//            let matches = detector.matches(
//                in: req,
//                range: NSRange(req.startIndex..., in: req))
//            for match in matches {
//                let start = req.index(
//                    req.startIndex,
//                    offsetBy: match.range.lowerBound)
//                let end = req.index(
//                    req.startIndex,
//                    offsetBy: match.range.upperBound)
//                let range = start ..< end
//                let detail = req[range]
//                let info = detail
//                    .replacingOccurrences(of: "]", with: "")
//                    .replacingOccurrences(of: "[", with: "")
//                    .split(separator: ":")
//                if info.count > 1{
//                    let title = String(info[0])
//                    let value = String(info[1])
//                    tempDetails.append(TaskField(title: title, value: value))
//                }
//            }
//        }catch{
//
//        }
//        return tempDetails
    }
    
}

extension TaskManager2 {
    
    static func generateCompleteTasks(num : Int) -> [Task]{
        var temp : [Task] = []
        for i in 0..<num {
            let task = Task(
                id: "\(i)",
                request: "Complete Task #\(i) : ",
                date: "2021-04-01 12:00:00",
                status: "5",
                type: "user_requested")
            temp.append(task)
        }
        return temp
    }
    
    static func generateOpenTasks(num : Int) -> [Task]{
        var temp : [Task] = []
        for i in 0..<num {
            let task = Task(
                id: "\(i)",
                request: "Open Task #\(i) : ",
                date: "2021-04-01 12:00:00",
                status: "2",
                type: "user_requested")
            temp.append(task)
        }
        return temp
    }
    
}

struct TaskField {
    
    var id = UUID()
    var title : String
    var value : String
    
}
