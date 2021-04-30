//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 4/29/21.
//

import Foundation
import SwiftUI

public struct Content_TaskCalendar : PublicFacingContent {
    @ObservedObject public var manager: Manager
    
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        TaskCalendar(taskManager: manager as! TaskManager2)
    }
}

struct TaskCalendar : View {
    
    @State var taskManager : TaskManager2
    @State var makingNewTask = false
    
    var body: some View {
        VStack{
            CalendarView2()
        }
    }
}
