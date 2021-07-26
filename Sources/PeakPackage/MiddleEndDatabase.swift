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
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: message, requiringSecureCoding: false)
            UserDefaults.standard.setValue(encodedData, forKey: "dashboardMessage")
        } catch {
            //do nothing
            printr("Could not encode dashboardMessage")
        }
    }
    static func getDashboardMessage() -> DashboardMessage?{
        var decodedObj : DashboardMessage? = nil
        do {
            let decoded = UserDefaults.standard.value(forKey: "dashboardMessage") as! Data
            decodedObj = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? DashboardMessage
        } catch {
            printr("Could not decode dashboardMessage")
        }
        return decodedObj
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
