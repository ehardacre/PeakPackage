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
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(message)
            UserDefaults.standard.set(data, forKey: "dashboardMessage")
        } catch { printr("unable to encode dashboard message") }
    }
    static func getDashboardMessage() -> DashboardMessage?{
        if let data = UserDefaults.standard.data(forKey: "dashboardMessage"){
            do{
                let decoder = JSONDecoder()
                let object = try decoder.decode(DashboardMessage.self, from: data)
                return object
            }catch{ printr("unable to decode dashboard message") }
        }
        return nil
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
