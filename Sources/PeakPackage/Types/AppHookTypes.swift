//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/13/21.
//

import Foundation
import SwiftUI

//the swift format of a json object
typealias JSON = [String : Any]

//MARK: JSON Keys
/**
 #JSON Keys
 enumeration used for easily storing the keys that we use for the app hook
 */
enum JsonKeys : String{
    
    //MARK: ALL
    case admin_key = "admin"
    //keys for two factor auth
    case twofactor_type = "verification"
    case twofactor_contact = "contact"
    //key for getting the analytics id
    case analyticsId_key = "analytics_id_key"
    //get the message shown on the dashboard
    case dashboard_key = "dashboard_message"
    case dashboard_analytics_key = "dashboard_analytics_site_url"
    
    //MARK: PEAK CLIENTS
    //keys for recieving calls from the app
    case email_key = "email"
    case phone_key = "phone"
    //keys for a service request
    case tasks_key = "tasks" //this is where the user id will be stored
    case tasks_value = "request"
    //keys for changing and getting user data
    case userData_key = "user"
    case newAddress_key = "street_address_1" //these are the keys used in wp_usermeta
    case newCity_key = "city" // do not change
    case newState_key = "state" // do not change
    case newZip_key = "zip_code" // do not change
    case newPhone_key = "phone_number" // do not change
    case newEmail_key = "public_franchise_email" // do not change
    //keys for getting and setting appointments
    case appt_key = "appointments" //this is where the user id will be stored
    case appt_value = "appointment_reason"
    case appt_date = "appointment_date"
    case appt_dur = "appointment_duration"
    //the key for getting the notification token
    case notification_key = "notification_key"
    case notification_token = "notification_token"
    //the key for getting the dynamic form
    case form_key = "dynamicform_key"
    case form_type_key = "dynamicform_type_key"
    case image_send_key = "imageData"
    //key for converting kanban id to wp id
    case id_key = "id_key"
    
    //MARK: N-HANCE CONNECT
    //keys for getting leads
    case leadsType_key = "leads_type"
    case leadsFranchise_key = "franchise_id"
    //keys for getting the site url for N-Hance sites
    case analyticsUrl_key = "analytics_site_url"
    //accept and decline on-trac leads
    case accept_lead_key = "accept_weblead_id"
    case decline_lead_key = "delete_account_id"
    
}

//MARK: JSON Format
/**
    #JSON Format
     enumeration used for formating json for different database requests
 */
enum JsonFormat {
    
    //MARK: ALL
    //used to check for user in login process
    case getUserFromEmail(email: String)
    case getUserFromPhone(phone: String)
    //get the dashboard message shown to users
    case getDashboardMessage
    //two factor authentication
    case twoFactor(type: String, contact: String)
    //analytics jams
    case getDashboardAnalytics(url: String)
    case getAnanlytics(url: String)
    //takes the kanban id
    case getAnalyticsId(id: String)
    //store notification token
    //TODO: may not be needed anymore
    case setNotificationToken(id: String, token: String)
    
    
    //MARK: PEAK CLIENTS
    //profile operations
    case getUser(id: String)
    case setUser(id: String, address: String?, city: String?, state: String?, zip: String?, phone: String?, email: String?)
    //Oppointment Operations
    case getAppointments(id: String)
    case setAppointment(id: String, value: String, date: String, duration: String)
    //Task Operations
    case getTasks(id: String)
    case setTask(id: String, value: String)
    case setTaskWithImage(id: String, value: String, image: String)
    //id is the id of the form we're trying to get
    case getDynamicForm(id: String)
    case getDynamicFormTypes(id: String)
    
    
    //MARK: N-HANCE CONNECT
    //accept and decline leads through on-trac
    case acceptLead(franchiseId: String, leadId: String)
    case declineLead(franchiseId: String, accountId: String)
    //get leads from on-trac
    case getLeads(type: String, id: String)
    

    //format into the json form for the apphook
    func format() -> JSON {
        
        //MARK: format()
        
        //add the admin extension if admin
        let adminExt : [String : Any] = defaults.admin ? [JsonKeys.admin_key.rawValue: "true"] : [:]
        
        //the return value
        var retVal : [String : Any] = [:]
        
        switch self {
        
        //MARK: ALL
        //get user id from email address
        case .getUserFromEmail(let email):
            retVal = [JsonKeys.email_key.rawValue: email]
        //get user id from phone number
        case .getUserFromPhone(let phone):
            retVal = [JsonKeys.phone_key.rawValue: phone]
        //perform two factor authentication
        case .twoFactor(let type, let contact):
            retVal = [JsonKeys.twofactor_type.rawValue: type,
                JsonKeys.twofactor_contact.rawValue: contact]
        case.getDashboardMessage:
            retVal = [JsonKeys.dashboard_key.rawValue: "true"]
        case .setNotificationToken(let id, let token):
            retVal = [ JsonKeys.notification_key.rawValue: id, JsonKeys.notification_token.rawValue: token]
        //analytics
        case .getAnalyticsId(let id):
            retVal = [JsonKeys.analyticsId_key.rawValue: id]
        case .getDashboardAnalytics(let url):
            retVal = [JsonKeys.dashboard_analytics_key.rawValue: url]
        
        
        //MARK: PEAK CLIENTS
        case .getDynamicForm(let id):
            retVal = [JsonKeys.form_key.rawValue: id]
        case .getDynamicFormTypes(let id):
            retVal = [JsonKeys.form_type_key.rawValue: id]
            //get tasks for user id
        case .getTasks(let id):
            retVal = [JsonKeys.tasks_key.rawValue: id]
            //create task for id
        case .setTask(let id, let value):
            retVal = [JsonKeys.tasks_key.rawValue: id, JsonKeys.tasks_value.rawValue: value]
        case .setTaskWithImage(let id, let value, let image):
            retVal = [JsonKeys.tasks_key.rawValue: id, JsonKeys.tasks_value.rawValue: value, JsonKeys.image_send_key.rawValue: image]
            //get appointments for user id
        case .getAppointments(let id):
            retVal = [JsonKeys.appt_key.rawValue: id]
            //create appointments for user id
        case .setAppointment(let id, let value, let date, let duration):
            retVal = [JsonKeys.appt_key.rawValue: id,
                    JsonKeys.appt_value.rawValue: value,
                    JsonKeys.appt_date.rawValue: date,
                    JsonKeys.appt_dur.rawValue: duration]
            //get the user information from id
        case .getUser(let id):
            retVal = [JsonKeys.userData_key.rawValue: id]
            //update user information
        case .setUser(let id, let address, let city, let state, let zip, let phone, let email):
            var json = [JsonKeys.userData_key.rawValue: id]
            if address != nil { json[JsonKeys.newAddress_key.rawValue] = address! }
            if city != nil { json[JsonKeys.newCity_key.rawValue] = city! }
            if state != nil { json[JsonKeys.newState_key.rawValue] = state! }
            if zip != nil { json[JsonKeys.newZip_key.rawValue] = zip! }
            if phone != nil { json[JsonKeys.newPhone_key.rawValue] = phone! }
            if email != nil { json[JsonKeys.newEmail_key.rawValue] = email! }
            retVal = json
            
            
        //MARK: N-HANCE CONNECT
        case .acceptLead(let franchiseId, let leadId):
            retVal = [JsonKeys.leadsFranchise_key.rawValue: franchiseId, JsonKeys.accept_lead_key.rawValue: leadId]
        case .declineLead(let franchiseId, let accountId):
            retVal = [JsonKeys.leadsFranchise_key.rawValue: franchiseId, JsonKeys.decline_lead_key.rawValue: accountId]
        case .getAnanlytics(let url):
            retVal = [JsonKeys.analyticsUrl_key.rawValue: url]
        case .getLeads(let type, let id):
            retVal = [JsonKeys.leadsType_key.rawValue: type, JsonKeys.leadsFranchise_key.rawValue: id]
        
            
            //should never run
        default:
            
            printr(InternalError.nilContent.rawValue, tag: printTags.error)
            
        }
        
        return retVal.merging(adminExt, uniquingKeysWith: {(current, _) in current})
    }
}
