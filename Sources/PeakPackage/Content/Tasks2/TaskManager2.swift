//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/19/21.
//

import Foundation
import SwiftUI

//This is a merged task manager and appointment manager
public class TaskManager2 : Manager{
    
    static var taskTypes = [TaskStatus.open , TaskStatus.complete]
    static var adminTaskTypes = ["Open Tasks", "Complete"]
    
    @Published var tasks = [Task]()
    @Published var completedTasks = [Task]()
    @Published var openTasks = [Task]()
    @Published var forms = [AutoForm]()
    
    //@Published var myAppointments : Appointment
    @Published var unavailabaleTimeSlots : [appointmentTimeSlot] = []
    @Published var appointments : [Appointment] = []
    static let timeSlotInterval = 30 
    

    public override init(){}
    
    func loadForms(){
        if !forms.isEmpty{
            return
        }
        if defaults.admin {
            DatabaseDelegate.getAdminForms(completion: {
                rex in
                let adminforms = rex as! [AutoForm]
                self.forms.append(contentsOf: adminforms)
            })
        }
        DatabaseDelegate.getUserForms(completion: {
            rex in
            let userforms = rex as! [AutoForm]
            self.forms.append(contentsOf: userforms)
        })
    }
    
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
    
    func reloadTasks(){
        DatabaseDelegate.getTasks(completion: {
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
        //for correct date ordering
        openTasks.reverse()
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
    
    static func stringDateToDate(_ strdate: String) -> Date{
        let dateFormatter = DateFormatter()
        //2020-10-13 18:07:12
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datedate = dateFormatter.date(from: strdate)
        return datedate ?? Date()
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
    func convert(tasks: [Task], selectionManager: SelectionManager, taskManager: TaskManager2) -> [TaskCardView2] {
        //empty list of cards
        var cards : [TaskCardView2] = []
        //loop through tasks and individually convert them
        for task in tasks {
            cards.append(task.convertToCard(with: selectionManager, and: taskManager))
        }
        return cards.reversed()
    }
    
    //gets open tasks after a given date
    func getOpenTasks(for date: Date) -> [Task]{
        var tasklist : [Task] = []
        printr("in open tasks: \(openTasks.count)")
        for task in openTasks {
            var taskdate = TaskManager2.stringDateToDate(task.date)
            var diff = Calendar.current.dateComponents([.day], from: taskdate, to: date)
            if diff.day ?? -1 >= 0 {
                tasklist.append(task)
            }
        }
        return tasklist
    }
    
    func getCompleteTasks(for date: Date) -> [Task]{
        var tasklist : [Task] = []
        printr("in completed tasks: \(completedTasks.count)")
        for task in completedTasks {
            var taskdate = TaskManager2.stringDateToDate(task.date)
            var diff = Calendar.current.dateComponents([.day], from: taskdate, to: date)
            if diff.day == 0 {
                tasklist.append(task)
            }
        }
        return tasklist
    }
    
    func convertForCalendar(tasks: [Task], selectionManager: SelectionManager, taskManager: TaskManager2) -> [TaskCalendarCardView]{
        
        var cards : [TaskCalendarCardView] = []
        
        for task in tasks {
            cards.append(task.convertToCalendarCard(with: selectionManager, and: taskManager))
        }
        
        return cards.reversed()
    }
    
    func getAppointments(for date: Date) -> [Appointment]{
        var appList : [Appointment] = []
        for app in appointments {
            var appDate = app.getDate().advanced(by: 12*60*60)
            //addDate needs to be advanced so it doesn't lie exactly on midnight
            var diff = Calendar.current.dateComponents([.hour], from: appDate, to: date)
            if diff.hour! < 9 && diff.hour! > -9{ //nine or so hours from noon is the cut off
                appList.append(app)
            }
        }
        return appList.sorted(by: {return $0.startHour() > $1.startHour()})
    }
    
    func getAppointments(after date: Date) -> [Appointment]{
        var appList : [Appointment] = []
        for app in appointments {
            var appDate = app.getDateWithEndHour()
            //addDate needs to be advanced so it doesn't lie exactly on midnight
            var diff = Calendar.current.dateComponents([.hour], from: appDate, to: date)
            if diff.hour! <= 0 && diff.hour! > -12{ //nine or so hours from noon is the cut off
                appList.append(app)
            }
        }
        return appList.sorted(by: {return $0.startHour() > $1.startHour()})
    }
    
    func convertForCalendar(appointments: [Appointment], selectionManager: SelectionManager, taskManager: TaskManager2) -> [AppointmentCardView]{
        
        var cards : [AppointmentCardView] = []
        
        for app in appointments {
            cards.append(app.convertToCalendarCard(with: selectionManager, and: taskManager))
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
    }
    
    // MARK: Appoinment Functions
    
    func loadAppointments(){
        DatabaseDelegate.getAppointments(completion: {
            rex in
            self.appointments = rex as! [Appointment]
        })
    }
    
    func loadUnavailableAppointmentTimes(){
        DatabaseDelegate.getUnavalableAppointments(completion: {
            rex in
            self.unavailabaleTimeSlots = rex as! [appointmentTimeSlot]
        })
    }
    
    func reloadAppointmentData(){
        loadUnavailableAppointmentTimes()
        loadAppointments()
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
