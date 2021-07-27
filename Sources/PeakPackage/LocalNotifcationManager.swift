//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 7/23/21.
//

import Foundation
import SwiftUI

enum LocalNotificationTypes : String {
    //database
    case database = "loadedDatabase"
    //loaded
    case loadedDashboardMessage = "loadedDashboardMessage"
    case loadedDashboardAnalytics = "loadedDashboardAnalytics"
    case loadedFranchiseList = "loadedFranchiseList"
    case loadedSEORanks = "loadedSEORanks"
    case loadedSEOScrape = "scrapedSEORanks"
    //changed
    case changedDate = "changedDate"
    case changedProfile = "changedProfile"
    case changedFranchiseForTask = "changedFranchiseForTask"
    
    func postName() -> Notification.Name{
        return Notification.Name(self.rawValue)
    }
}
