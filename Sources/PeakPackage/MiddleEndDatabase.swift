//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 7/23/21.
//

import Foundation
import SwiftUI

struct MiddleEndDatabase {
    
    static func setDashboardMessage(message: DashboardMessage){
        UserDefaults.standard.setValue(message, forKey: "dashboardMessage")
    }
    static func getDashboardMessage() -> DashboardMessage?{
        return UserDefaults.standard.value(forKey: "dashboardMessage") as? DashboardMessage
    }
    
    static func setDashboardAnalytics(analytics: Analytics){
        UserDefaults.standard.setValue(analytics, forKey: "dashboardAnalytics")
    }
    
    static func getDashboardAnalytics() -> Analytics? {
        return UserDefaults.standard.value(forKey: "dashboardAnalytics") as? Analytics
    }
    
    static func getDashboardMessage() -> DashboardMessage {
        return DashboardMessage(dashMessageTitle: "Default", dashMessageBody: "this is the last message that was loaded", dashMessageLink: "")
    }
    
}
