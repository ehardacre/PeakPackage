//
//  AppointmentManager.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 8/26/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class AppointmentManager : ObservableObject {
    
    @Published var appointments = [Visit]()
    @Published var todaysAppointments = [Visit]()
    
    func isValidAppointment(_ date: Date? = nil){
        
    }
    
    /**
    #loadAppointments
    */
    func loadAppointments(){
        
        //check if appointments have already been populated
        if !appointments.isEmpty {
            return
        }
        
        //format the json for the request
        let json = JsonFormat.getAppointments(id: defaults.franchiseId()!).format()
        
        //perform the database operation
        DatabaseDelegate.performRequest(with: json, ret: returnType.visit, completion: {
             rex in
            
            //convert the backend format to the front end format
            self.appointments = (rex as! [BackendVisit]).map(self.makeFrontendVisit(visit:))
            self.loadTodaysVisits()
         })
     }
    
    func resetAppointments(){
        appointments = []
        _ = loadAppointments()
    }
     
     private func loadDummyAppointments(){
         appointments = [
            Visit(locationName: "Example Appt.", tagColor: Color(UIColor(named: "Peak")!), arrivalDate: Date(), departureDate: Date())
         ]
     }
     
     func loadTodaysVisits(){
         var todays = [Visit]()
         for v in appointments{
             //TODO: calculate this differently to only include appointments on this actual day not within 24 hours
             let diff = Calendar.current.dateComponents([.day], from: Date(), to: v.arrivalDate)
             if diff.day == 0 {
                todays.append(v)
             }
         }
         todaysAppointments = todays
     }
     
    private func makeFrontendVisit(visit: BackendVisit) -> Visit{
        let nullVisit = Visit(locationName: "null", tagColor: .clear, arrivalDate: .distantPast, departureDate: .distantPast)
        return visit.convert() ?? nullVisit
    }
    
}

extension BackendVisit{
    func convert() -> Visit?{
        let date = self.date
        if date.count != 14 || !date.isNumeric{
            return nil
        }
        let start = date.startIndex
        let end = date.endIndex
        
        let ye = date.index(start, offsetBy: 4)
        let me = date.index(ye, offsetBy: 2)
        let de = date.index(me, offsetBy: 2)
        let he = date.index(de, offsetBy: 2)
        let mne = date.index(he, offsetBy: 2)
        
        let y = date[start..<ye]
        let m = date[ye..<me]
        let d = date[me..<de]
        let h = date[de..<he]
        let mn = date[he..<mne]
        let s = date[mne..<end]
        let hInt = Int(h)!
        
        let dateString = "\(y)-\(m)-\(d)T\(hInt):\(mn):\(s)+0000"
        
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter4.timeZone = TimeZone(abbreviation: "UTC")
        let formattedDate = formatter4.date(from: dateString)
        
        if formattedDate == nil{
            return nil
        }
        
        var description = self.desc
        if self.desc == ""{
            description = "Unknown Call"
        }
        
        let duration = Double(self.dur.makeNumeric()) ?? 0.0
        
        
        let visit : Visit = Visit(locationName: description, tagColor: Color.main, arrivalDate: formattedDate!, departureDate: Date(timeInterval: duration*60, since: formattedDate!))
        
        return visit
    }
}
