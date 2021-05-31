//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/13/21.
//

import Foundation

/**
 # User Type
is used in the profile view to contain all of the users data such as:
 
 * address
 * city
 * state
 * zip
 * phone
 * email

 */
struct UserType: Codable{
    var city: String
    var phone: String
    var email: String
    var state: String
    var address: String
    var zip: String
}


/**
 # Franchise
 This holds the relevant information about a franchise such as it's Id and name
 
 TODO: is this even used? seems redundant with UserType
 */
struct Franchise: Codable{
    var franchiseId: String
    var franchiseTitle: String
    var franchiseURL: String
    var twoFactor: String
    var location: String?
}

/**
 # Backend Visit
 This is the format that appoinments are returned in from the DB
 
 * date
 * desc - description of the appointment
 * dur - duration of the appointment
 */
struct BackendVisit: Codable{
    var date: String
    var desc: String
    var dur: String
}

/**
 #Lead
 Used to be notification
 */
struct Lead: Codable{
    var notification_id: String
    var notification_state: String
    var notification_topic: String?
    var notification_key: String
    var notification_value: LeadInformation
    var notification_date: String
}

struct LeadInformation : Codable{
    var note : String?
    var email : String?
    var phone : String?
    var account_id : String?
    var source : String?
    var lead_number : String?
    var job_type : String?
    var job_address : String?
    var job_date : String?
    var technician_name : String?
    var lead_category : String?
    var lead_source : String?
    var lead_group : String?
    
}

struct DashboardMessage: Codable{
    var dashMessageTitle : String
    var dashMessageBody : String
    var dashMessageLink : String
}

//an order from woocommerce has the same fields as Lead
typealias Order = Lead

class SearchRankingforTime : Codable{

    var week : String
    var list : [SearchRanking]
}

class SearchRanking : Codable{
    
    var id : String
    var keyword : String
    var maps_ranking : String?
    var organic_ranking : String?
    
}

class appointmentTimeSlot : Codable{
    var date : String
    var start : String
    var end : String
}

extension appointmentTimeSlot{
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self.date)
    }
    
    func getStartTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let retDate = formatter.date(from: self.start)
        let locDate = retDate?.toLocalTime()
        return locDate
    }
    
    func getEndTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let retDate = formatter.date(from: self.end)
        let locDate = retDate?.toLocalTime()
        return locDate
    }
}

class Appointment : Codable{
    var id : String
    var date : String
    var franchise: String
    var name : String
    var start : String
    var end : String
    var description : String
}

extension Appointment{
    
    //returns minute difference
    func getDuration() -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        guard let startDate = formatter.date(from: self.start) else { return 0 }
        guard let endDate = formatter.date(from: self.end) else { return 0 }
        return Int((startDate.distance(to: endDate))/60)
    }
    
    func getName() -> String{
        if defaults.admin {
            return name
        } else {
            return "Peak Studios"
        }
    }
    
    func startHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "HH"
        formatterTwo.timeZone = .current
        
        guard let startDate = formatter.date(from: self.date + " " + self.start) else { return "" }
        let startStr = formatterTwo.string(from: startDate)
        
        return startStr
    }
    
    func startMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "mm"
        formatterTwo.timeZone = .current
        
        guard let startDate = formatter.date(from: self.date + " " + self.start) else { return "" }
        let startStr = formatterTwo.string(from: startDate)
        
        return startStr
    }
    
    func endHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "HH"
        formatterTwo.timeZone = .current
        
        guard let endDate = formatter.date(from: self.date + " " + self.end) else { return "" }
        let endStr = formatterTwo.string(from: endDate)
        
        return endStr
    }
    
    func endMinute() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "mm"
        formatterTwo.timeZone = .current
        
        guard let endDate = formatter.date(from: self.date + " " + self.end) else { return "" }
        let endStr = formatterTwo.string(from: endDate)
        
        return endStr
    }
    
    func getDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        guard let startDate = formatter.date(from: self.date) else {
            return Calendar.current.date(bySetting: .year, value: 2018, of: Date())!
        }
        return startDate
    }
    
    func getDateWithEndHour() -> Date{
        let hours = TimeInterval(endHour().digits.integer!*60*60)
        let minutes = TimeInterval(endMinute().digits.integer!*60)
        return getDate().advanced(by: hours+minutes)
    }
    
    func getDateWithStartHour() -> Date{
        let hours = TimeInterval(startHour().digits.integer!*60*60)
        let minutes = TimeInterval(startMinute().digits.integer!*60)
        return getDate().advanced(by: hours+minutes)
    }
    
    func convertToCalendarCard(with selectionManager: SelectionManager, and taskManager: TaskManager2) -> AppointmentCardView{
        
        return AppointmentCardView(id: UUID(),
                                   selectionManager: selectionManager,
                                   taskManager: taskManager,
                                   appointment: self)
        
    }
}

class franchiseGroupTag : Codable {
    
    var groupName : String
    var ids : String
    
}

extension franchiseGroupTag {
    
    func toTagforView() -> Tag {
        return Tag(name: groupName, franchiseList: ids)
    }
    
}


/**
 # Return Type
 This enum keeps track of the different return types from the database so that they can be easily referenced
 
 TODO: Is there a way to assign raw values to these types so that they don't have to be checked and then referenced in if else statements.
 */
enum returnType {
    case formtype
    case form
    case taskList
    case franchiseList
    case user
    case visit
    case analytics
    case leads
    case string
    case dashboardMessage
    case searchRank
    case appointmentTimeSlot
    case appointment
    case grouptag
}
