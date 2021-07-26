//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 7/23/21.
//

import Foundation
import SwiftUI

enum LocalNoteType : String{
    case loaded = "loaded"
    case changed = "changed"
    case failed = "failed"
}

enum LocalNoteSubjects : String{
    case dashboardMessage = "DashboardMessage"
    case dashboardAnalytics = "DashboardAnalytics"
    case SEORanks = "SEORanks"
    case profile = "Profile"
}

struct LocalNotificationManager {
    
    static func postNamefor(type: LocalNoteType, subject: String) -> Notification.Name{
        return Notification.Name(type.rawValue + subject)
    }
    
    static func sendNotification(type: LocalNoteType, subject: String, object: Any? = nil){
        NotificationCenter.default.post(Notification(name: postNamefor(type: type, subject: subject),object: object))
    }
}
