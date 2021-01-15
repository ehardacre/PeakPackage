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
}

//an order from woocommerce has the same fields as Lead
typealias Order = Lead

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
}
