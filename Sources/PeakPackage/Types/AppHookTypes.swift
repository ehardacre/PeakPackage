//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/13/21.
//

import Foundation
import SwiftUI

//the swift format of a json object
public typealias JSON = [String : Any]

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
    case twofactor_current = "tf_code"
    //get the message shown on the dashboard
    case dashboard_key = "dashboard_message"
    case dashboard_check_key = "dashboard_check_url"
    //notification values
    case add_notification_key = "device_id"
    case add_notification_cat_key = "notification_category"
    //analytics keys
    case week_analytics_key = "week_analytics_site_url"
    case month_analytics_key = "month_analytics_site_url"
    case year_analytics_key = "year_analytics_site_url"
    case day_analytics_key = "dashboard_analytics_site_url"
    //seo ranking keys
    case seo_url_key = "rank_franchise_url"
    case seo_keyword_key = "rank_keyword"
    case seo_mapranking_key = "maps_ranking"
    case seo_organicranking_key = "organic_ranking"
    case seo_site_key = "from_site"
    case seo_get_key = "get_ranks_url"
    //dynamic forms for tasks (currently just on peak)
    case get_forms_key = "get_dynamic_forms"
    case submit_form_key = "new_form_title"
    case submit_form_subkey = "new_form_subtitle"
    case submit_form_visibility_key = "new_form_admin"
    case submit_form_elements_key = "new_form_element_formID"
    case submit_form_element_label = "new_form_element_label"
    case submit_form_element_prompt = "new_form_element_prompt"
    case submit_form_element_input = "new_form_element_input"
    
    //MARK: PEAK CLIENTS
    //keys for recieving calls from the app
    case email_key = "email"
    case phone_key = "phone"
    //keys for a service request
    case tasks_key = "tasks" //this is where the user id will be stored
    case tasks_value = "request"
    case tasks_update_key = "task_update"
    case tasks_update_status = "task_update_status"
    //keys for changing and getting user data
    case userData_key = "user"
    case newAddress_key = "street_address_1" //these are the keys used in wp_usermeta
    case newCity_key = "city" // do not change
    case newState_key = "state" // do not change
    case newZip_key = "zip_code" // do not change
    case newPhone_key = "phone_number" // do not change
    case newEmail_key = "public_franchise_email" // do not change
    //keys for getting and setting appointments
    #warning("DEPRECATED")
    case appt_key = "appointments" //this is where the user id will be stored
    case appt_value = "appointment_reason"
    case appt_date = "appointment_date"
    case appt_dur = "appointment_duration"
    //the key for getting the dynamic form
    case form_key = "dynamicform_key"
    case form_type_key = "dynamicform_type_key"
    case image_send_key = "imageData"
    case image_send_task = "image_taskID"
    //key for converting kanban id to wp id
    case id_key = "id_key"
    //Leads
    case peak_leads_key = "get_leads_topic_key"
    case peak_updateLeadsID_key = "update_leads_id_key"
    case peak_updateLeadsState_key = "update_leads_state_key"
    //WOOCOMMERCE:
    case woo_leads_key = "get_unspilt_leads_topic_key"
    case woo_updateLeadsID_key = "update_unspilt_leads_id_key"
    case woo_updateLeadsState_key = "update_unspilt_leads_state_key"
    //new appointment key
    case unavailableTimeSlots_key = "getUnavailableTimeSlots"
    
    //MARK: N-HANCE CONNECT
    //keys for getting leads
    case leadsType_key = "leads_type"
    case leadsFranchise_key = "franchise_id"
    //accept and decline on-trac leads
    case accept_lead_key = "accept_weblead_id"
    case decline_lead_key = "delete_account_id"
    //getting the list of profiles
    case get_profiles_key = "franchise_ids_and_urls"
    
    
}

//MARK: JSON Format
/**
    #JSON Format
     enumeration used for formating json for different database requests
 */
public enum JsonFormat {
    
    //MARK: ALL
    //used to check for user in login process
    case getUserFromEmail(email: String)
    case getUserFromPhone(phone: String)
    //get the dashboard message shown to users
    case getDashboardMessage(url: String)
    //two factor authentication
    case twoFactor(type: String, contact: String)
    case resendTwoFactor(contact: String, code: String)
    //takes the kanban id
    case getAnalyticsId(id: String)
    //store notification token
    case setNotificationToken(token: String, category: String)
    //analytics jams
    case getDashboardAnalytics(url: String)
    case getWeekAnalytics(url: String)
    case getMonthAnalytics(url: String)
    case getYearAnalytics(url: String)
    //seo
    case setSEORankings(url: String, keyword: String, mapRanking: String, organicRanking: String, site: String)
    case getSEORankings(url: String)
    //dynamic forms for tasks (currently just on peak)
    //visabilities include: "admin","peak","nhance"
    case getForms(visability: String)
    case submitForm(title: String, subtitle: String, visability: String)
    case submitFormElement(formID: String, label: String, prompt: String, input: String)
    
    
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
    case updateTaskStatus(taskId: String, status: String)
    #warning("DEPRECATED")
    case setTaskWithImage(id: String, value: String, image: String)
    case sendImagesforTask(taskId: String, imageData: String)
    //id is the id of the form we're trying to get
    case getDynamicForm(id: String)
    case getDynamicFormTypes(id: String)
    //peak leads and such
    case getLeads_peak(topic: String)
    case updateLeads_peak(id: String, state: String)
    //woo commerce leads
    case getLeads_woo(topic: String)
    case updateLeads_woo(id: String, state: String)
    //new appointments
    case getUnavailableAppoinmentSlots
    
    
    //MARK: N-HANCE CONNECT
    //accept and decline leads through on-trac
    case acceptLead(franchiseId: String, leadId: String)
    case declineLead(franchiseId: String, accountId: String)
    //get leads from on-trac
    case getLeads_nhance(type: String, id: String)
    //get the list of profiles
    case getProfiles
    
    

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
        case .resendTwoFactor(let contact, let code):
            retVal = [JsonKeys.twofactor_contact.rawValue: contact,
                      JsonKeys.twofactor_current.rawValue: code]
        case .getDashboardMessage(let url):
            retVal = [JsonKeys.dashboard_key.rawValue: "true", JsonKeys.dashboard_check_key.rawValue: url]
        case .setNotificationToken(let token, let category):
            retVal = [JsonKeys.add_notification_key.rawValue: token,
                      JsonKeys.add_notification_cat_key.rawValue: category]
        case .getWeekAnalytics(let url):
            retVal = [JsonKeys.week_analytics_key.rawValue: url]
        case .getMonthAnalytics(let url):
            retVal = [JsonKeys.month_analytics_key.rawValue: url]
        case .getYearAnalytics(let url):
            retVal = [JsonKeys.year_analytics_key.rawValue: url]
        case .getDashboardAnalytics(let url):
            retVal = [JsonKeys.day_analytics_key.rawValue: url]
        case .setSEORankings(let url, let keyword, let mapRanking, let organicRanking, let site):
            retVal = [JsonKeys.seo_url_key.rawValue: url,
                      JsonKeys.seo_keyword_key.rawValue: keyword,
                      JsonKeys.seo_mapranking_key.rawValue: mapRanking,
                      JsonKeys.seo_organicranking_key.rawValue: organicRanking,
                      JsonKeys.seo_site_key.rawValue: site]
        case .getSEORankings(let url):
            retVal = [JsonKeys.seo_get_key.rawValue: url]
        case .getForms(let visability):
            retVal = [JsonKeys.get_forms_key.rawValue: visability]
        case .submitForm(let title, let subtitle, let visability):
            retVal = [JsonKeys.submit_form_key.rawValue: title,
                      JsonKeys.submit_form_subkey.rawValue: subtitle,
                      JsonKeys.submit_form_visibility_key.rawValue: visability]
        case .submitFormElement(let formID, let label, let prompt, let input):
            retVal = [JsonKeys.submit_form_elements_key.rawValue: formID,
                      JsonKeys.submit_form_element_label.rawValue: label,
                      JsonKeys.submit_form_element_prompt.rawValue: prompt,
                      JsonKeys.submit_form_element_input.rawValue: input]
        
        
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
        case .updateTaskStatus(let taskId, let status):
            retVal = [JsonKeys.tasks_update_key.rawValue: taskId,
                      JsonKeys.tasks_update_status.rawValue: status]
            #warning("DEPRECATED")
        case .setTaskWithImage(let id, let value, let image):
            retVal = [JsonKeys.tasks_key.rawValue: id, JsonKeys.tasks_value.rawValue: value, JsonKeys.image_send_key.rawValue: image]
        case .sendImagesforTask(let taskId, let imageData):
            retVal = [JsonKeys.image_send_key.rawValue: imageData,
                      JsonKeys.image_send_task.rawValue: taskId]
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
        //peak leads and such
        case .getLeads_peak(let topic):
            retVal = [JsonKeys.peak_leads_key.rawValue: topic]
        case .updateLeads_peak(let id, let state):
            retVal = [JsonKeys.peak_updateLeadsID_key.rawValue: id, JsonKeys.peak_updateLeadsState_key.rawValue: state]
        //woo commerce leads
        case .getLeads_woo(let topic):
            retVal = [JsonKeys.woo_leads_key.rawValue: topic]
        case .updateLeads_woo(let id, let state):
            retVal = [JsonKeys.woo_updateLeadsID_key.rawValue: id,
                      JsonKeys.woo_updateLeadsState_key.rawValue: state]
        //new appointment stuff
        case .getUnavailableAppoinmentSlots:
            retVal = [JsonKeys.unavailableTimeSlots_key.rawValue: "true"]
            
            
        //MARK: N-HANCE CONNECT
        case .acceptLead(let franchiseId, let leadId):
            retVal = [JsonKeys.leadsFranchise_key.rawValue: franchiseId, JsonKeys.accept_lead_key.rawValue: leadId]
        case .declineLead(let franchiseId, let accountId):
            retVal = [JsonKeys.leadsFranchise_key.rawValue: franchiseId, JsonKeys.decline_lead_key.rawValue: accountId]
        case .getLeads_nhance(let type, let id):
            retVal = [JsonKeys.leadsType_key.rawValue: type, JsonKeys.leadsFranchise_key.rawValue: id]
        case.getProfiles:
            retVal = [JsonKeys.get_profiles_key.rawValue : "get"]
            
            //should never run
        default:
            printr(InternalError.nilContent.rawValue, tag: printTags.error)
            
        }
        
        return retVal.merging(adminExt, uniquingKeysWith: {(current, _) in current})
    }
}
