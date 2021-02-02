//
//  NotificationManager.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/5/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import UserNotifications

public class NotificationManager : ObservableObject {
    
    static let pages = ["Open", "Accepted", "Scheduled"]

    @Published var newNotifications = 0
    @Published var starredLeads = 0
    @Published var leads = [Lead]()
    
    //normal
    @Published var open_leads = [Lead]()
    @Published var accepted_leads = [Lead]()
    @Published var scheduled_leads = [Lead]()
    
    @Published var loaded = false
    var loading = [false, false, false]
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadOnOpen), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func reloadOnOpen() {
        loaded = false
        loading = [false, false, false]
        loadNotifications()
    }
    
    func todaysScheduled() -> [Lead]{
        typealias LeadTime = (lead: Lead, time: TimeInterval)
        var temp : [LeadTime] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        for lead in scheduled_leads {
            
            var date = dateFormatter.date(from:lead.notification_date)!
            date = date.toLocalTime()
            if Calendar.current.isDateInToday(date) {
                temp.append((lead: lead, time: date.timeIntervalSince(Date())))
            }
        }
        
        temp.sort(by: {$0.time < $1.time})
        
        return temp.map({return $0.lead})
    }
    
    func formatDate(_ str_date: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        
        date = date.toLocalTime()
        
        var dateString = date.dayOfWeekWithMonthAndDay
        
    
        return dateString
    }
    
    func formatTime(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        
        date = date.toLocalTime()
        
        var dateString = date.timeOnlyWithPadding
        
    
        return dateString
    }
    
    func loadNotifications(){
        let topic = defaults.getTopics()
        printr(topic)
        
        //open, accepted, scheduled
        let json_new = JsonFormat.getLeads(type: "open", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_new, ret: returnType.leads, completion: { rex in
            let leads = rex as! [Lead]
            self.open_leads = leads
            self.newNotifications = leads.count
            self.loading[0] = true
            self.loaded = self.checkForLoading()
        })
        
        let json_acc = JsonFormat.getLeads(type: "accepted", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_acc, ret: returnType.leads, completion: { rex in
            let leads = rex as! [Lead]
            self.accepted_leads = leads
            self.loading[1] = true
            self.loaded = self.checkForLoading()
        })
        
        let json_sch = JsonFormat.getLeads(type: "scheduled", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_sch, ret: returnType.leads, completion: { rex in
            let leads = rex as! [Lead]
            self.scheduled_leads = leads
            self.loading[2] = true
            self.loaded = self.checkForLoading()
        })
        
    }
    
    func checkForLoading() -> Bool{
        
        for part in self.loading{
            if !part{
                return part
            }
        }
        
        return true
        
    }
    
    
}
    
