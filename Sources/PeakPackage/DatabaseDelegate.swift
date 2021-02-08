//
//  DatabaseDelegate.swift
//  Peak Client
//
//  Created by Ethan Hardacre  on 7/7/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import Foundation
import SwiftUI

extension DatabaseDelegate {
    
    static func getDashboardAnalytics(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients{
            let id = defaults.franchiseId()!
            let json = JsonFormat.getDashboardAnalytics_peak(id: id).format()
            DatabaseDelegate.performRequest(with: json, ret: returnType.analytics, completion:{
                rex in
                completion(rex)
            })
        }else if defaults.getApplicationType() == .NHanceConnect {
            let analyticsURL = defaults.franchiseURL()!.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "https:www.nhance.com", with: "")
            let dashboardJson = JsonFormat.getDashboardAnalytics_nhance(url: analyticsURL).format()
            DatabaseDelegate.performRequest(with: dashboardJson, ret: returnType.analytics, completion: {
                rex in
                completion(rex)
            })
        }else{
            printr("Application Type not set, could not get dashboard analytics")
        }
    }
    
    static func getAnalytics(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients{
            let id = defaults.franchiseId()!
            let json_id = JsonFormat.getAnalyticsId(id: id).format()
            DatabaseDelegate.performRequest(with: json_id, ret: returnType.string, completion: { analytics_id in
                
                let json = JsonFormat.getAnalytics_peak(id: analytics_id as! String).format()
                DatabaseDelegate.performRequest(with: json, ret: returnType.analytics, completion:{
                    rex in
                    completion(rex)
                })
                
            })
        }else if defaults.getApplicationType() == .NHanceConnect {
            let analyticsURL = defaults.franchiseURL()!.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "https:www.nhance.com", with: "")
            let json = JsonFormat.getAnalytics_nhance(url: analyticsURL).format()
            DatabaseDelegate.performRequest(with: json, ret: returnType.analytics, completion: { rex in
                completion(rex)
            })
        }else{
            printr("Application Type not set, could not get analytics")
        }
    }
    
    static func getAppointments(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients{
            //format the json for the request
            let json = JsonFormat.getAppointments(id: defaults.franchiseId()!).format()
            //perform the database operation
            DatabaseDelegate.performRequest(with: json, ret: returnType.visit, completion: {
                 rex in
                completion(rex)
             })
        }else if defaults.getApplicationType() == .NHanceConnect {
            printr("App type is set to NHance Connect, there are no appointments for NHance Connect")
        }else{
            printr("Application Type not set, could not get appointments")
        }
    }
    
    static func getDashboardMessage(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients{
            let json = JsonFormat.getDashboardMessage.format()
            DatabaseDelegate.performRequest(with: json, ret: returnType.dashboardMessage, completion: {
                rex in
                completion(rex)
            })
        }else if defaults.getApplicationType() == .NHanceConnect {
            let json = JsonFormat.getDashboardMessage.format()
            DatabaseDelegate.performRequest(with: json, ret: returnType.dashboardMessage, completion: {
                rex in
                completion(rex)
            })
        }else{
            printr("Application Type not set, could not get dashboard message")
        }
    }
    
    static func getOpenLeads(completion: @escaping (Any) -> Void){
        let topic = defaults.getTopics()
        let json_new = JsonFormat.getLeads_nhance(type: "open", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_new, ret: returnType.leads, completion: { rex in
           completion(rex)
        })
    }
    
    static func getAcceptedLeads(completion: @escaping (Any) -> Void){
        let topic = defaults.getTopics()
        let json_acc = JsonFormat.getLeads_nhance(type: "accepted", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_acc, ret: returnType.leads, completion: { rex in
            completion(rex)
        })
    }
    
    static func getScheduledLeads(completion: @escaping (Any) -> Void){
        let topic = defaults.getTopics()
        let json_sch = JsonFormat.getLeads_nhance(type: "scheduled", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_sch, ret: returnType.leads, completion: { rex in
            completion(rex)
        })
    }
    
    static func getPeakLeads(completion: @escaping (Any) -> Void){
        
        //TODO: add woo commerce
        let topic = defaults.getTopics()
        let json = JsonFormat.getLeads_peak(topic: topic).format()
        DatabaseDelegate.performRequest(with: json, ret: returnType.leads, completion: {
            rex in
            completion(rex)
        })
        
    }
    
    static func getTasks(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients{
            let json = JsonFormat.getTasks(id: defaults.franchiseId()!).format()
            //perform data base request
            DatabaseDelegate.performRequest(with: json, ret: returnType.taskList, completion: {
                    rex in
                    completion(rex)
            })
        }else if defaults.getApplicationType() == .NHanceConnect {
            printr("NHance Connect App does not use tasks")
        }else{
            printr("Application Type not set, could not get Tasks")
        }
    }
    
    static func getRatings(completion: @escaping (Any) -> Void){
        printr("ratings not set up yet")
    }
    
}

//MARK: Database Delegate
/**
 # Database Delegate
 The database delegate is responsible for communicating with the PSClients database
 
 # Use Cases
 * performRequest : performs a request to the PSClients DB
 ``` DatabaseDelegate.performRequest(with: _ ,ret: _, completion: { _ }) ```
 * getPassword : gets the password from the firebase DB
 */
struct DatabaseDelegate {
    
    
    //URL for apphook used for wordpress requests
    static private var str_url : String? = nil
    
    static func setURL(_ url: String){
        str_url = url
    }
    
    /**
            #performRequest
     - Parameter with: json style Dictionary that gets passed to the hook (you can format this using the JsonFormat type)
     - Parameter return: what type to expect back from the db
     - Parameter completion: function that gets called upon completion of the call
     
            in order to run this function you need to have called DatabaseDelegate.setURL
     */
    static func performRequest(with: [String: Any], ret: returnType, completion: @escaping (Any) -> Void){
        
        //MARK: performRequest
        
        //check that url isn't nil
        if str_url == nil {
            fatalError("The URL for the Database Delegate is empty. Please provide a URL for the data or the app is pointless. To do this you can call DatabaseDelegate.setURL")
        }
        
        //convert string to URL. Doesn't need error handling because it's constant
        guard let url = URL(string: self.str_url!) else {
            printr("The URL was unable to be cast into a correct URL. Please make sure that you provided a valid URL to the Database Delegate", tag: printTags.error)
            return
        }
        //http request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //convert dictionary input to json data
        let json: [String: Any] = with
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        printr(json)

        //open URL session with the request
        URLSession.shared.dataTask(with: request) { data, response, dberror in
            do{
                //check for errors in database connection
                if (dberror != nil) { throw DataError.badHook }
                //check for no data response
                guard let d = data else { throw DataError.nilResponse }
                //data base responses can be filtered for with ^
                printr(String.init(data: d, encoding: .ascii) ?? DataError.badFormat.rawValue, tag: printTags.database )
                //Convert data to readable response
                let rex = try objectFrom(data: d, type: ret)
                //run the completion function
                DispatchQueue.main.async {
                    completion(rex)
                }
            //error handling
            } catch DataError.badHook {
                printr(DataError.badHook.rawValue, tag: printTags.error)
            } catch DataError.nilResponse {
                printr(DataError.nilResponse.rawValue, tag: printTags.error)
            } catch {
                printr(InternalError.unknownError.rawValue + error.localizedDescription, tag: printTags.error)
            }
        }.resume()
    }
        
    
    /**
    # Object From data
     - Parameter data : describes the data from the database
     - Parameter type : describes the expected type of the data
     - Returns: type Any but can be cast to the expected type
     
     This function is used to convert from the Data returned to the expected return type
     */
    static func objectFrom(data: Data, type: returnType) throws -> Any{
        
        //MARK: objectFrom
        
        var rex : Any?
        //switch for the return type to determine which type to cast as
        switch type {
        case returnType.formtype:
            rex = try? JSONDecoder().decode([Form_Type].self, from: data)
        case returnType.form:
            rex = try? JSONDecoder().decode([Form_Element].self, from: data)
        case returnType.taskList:
            rex = try? JSONDecoder().decode([Task].self, from: data)
        case returnType.franchiseList:
            rex = try? JSONDecoder().decode([Franchise].self, from: data)
        case returnType.user:
            rex = try? JSONDecoder().decode(UserType.self, from: data)
        case returnType.visit:
            rex = try? JSONDecoder().decode([BackendVisit].self, from: data)
        case returnType.analytics:
            rex = try? JSONDecoder().decode([Analytics].self, from: data)
        case returnType.leads:
            rex = try? JSONDecoder().decode([Lead].self, from: data)
        case returnType.dashboardMessage:
            rex = try? JSONDecoder().decode(DashboardMessage.self, from: data)
        default:
            rex = String.init(data: data, encoding: .ascii)!
        }
        //rex cannot be nil from the data base
        guard rex != nil else { throw DataError.nilResponse }
        return rex!
    }
}
