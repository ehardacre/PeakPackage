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
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(analytics)
            UserDefaults.standard.set(data, forKey: "dashboardAnalytics")
        }catch{ printr("unable to encode dashboard analytics") }
    }
    
    static func getDashboardAnalytics() -> Analytics? {
        if let data = UserDefaults.standard.data(forKey: "dashboardAnalytics"){
            do{
                let decoder = JSONDecoder()
                let object = try decoder.decode(Analytics.self, from: data)
                return object
            }catch{ printr("unable to decode dashboard analytics") }
        }
        return nil
    }
}
