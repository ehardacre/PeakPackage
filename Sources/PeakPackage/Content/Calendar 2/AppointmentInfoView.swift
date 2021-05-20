//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 5/20/21.
//

import Foundation
import SwiftUI

struct AppointmentInfoView : View {
    
    @State var taskManager : TaskManager2
    @State var appointment : Appointment
    
    var body : some View {
        VStack{
            Text("\(appointment.startHour()):\(appointment.startMinute())-\(appointment.endHour()):\(appointment.endMinute())")
                .CardTitle()
            Divider()
            Text(appointment.franchise)
                .CardTitle()
            Text(appointment.description)
            Spacer()
            Text("Sheduled By: ")
                .Caption()
            Text(appointment.getName())
                .CardTitle()
        }
        .padding(30)
    }
    
}
