//
//  DatabaseDelegate.swift
//  Peak Client
//
//  Created by Ethan Hardacre  on 7/7/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

extension DatabaseDelegate {
    
    static func getAdminProfiles(completion: @escaping (Any) -> Void){
        let json = JsonFormat.getAdminProfiles.format()
        DatabaseDelegate.performRequest(with: json, ret: .adminProfileList, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func getFranchiseGroupTags(completion: @escaping (Any) -> Void){
        let json = JsonFormat.getFranchiseGroupTags.format()
        DatabaseDelegate.performRequest(with: json, ret: .grouptag, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func testNotification() {
        let token = defaults.getNotificationToken() ?? "no token"
        printr(token)
        let json = JsonFormat.testNotifications(notificationToken: token).format()
        DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
            rex in
            printr(rex)
        })
    }
    
    static func getAppointments(completion: @escaping (Any) -> Void){
        let id = defaults.franchiseId() ?? "1"
        let json = JsonFormat.getAppointments(id: id).format()
        DatabaseDelegate.performRequest(with: json, ret: returnType.appointment, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func getUnavalableAppointments(completion: @escaping (Any) -> Void){
        let json = JsonFormat.getUnavailableAppoinmentSlots.format()
        DatabaseDelegate.performRequest(with: json, ret: returnType.appointmentTimeSlot, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func setAppointment(franchiseId: String? = nil, franchiseName: String? = "", startTime: String, endTime: String, date: String, description: String, completion: @escaping (Any) -> Void){
        var id = defaults.franchiseId() ?? "1"
        if franchiseId != nil {
            id = franchiseId!
        }
        let name = defaults.getUsername() ?? "Owner"
        let json = JsonFormat.submitAppointment(id: id, franchise: franchiseName ?? "", name: name, start: startTime, end: endTime, date: date, description: description).format()
        DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func setNotificationTokens(){
        if defaults.getApplicationType() == .NHanceConnect{
            let json = JsonFormat.setNotificationToken(
                token: defaults.getNotificationToken()!,
                category: "nhance"+defaults.franchiseId()!)
                .format()
            DatabaseDelegate.performRequest(
                with: json,
                ret: returnType.string,
                completion:
                    {
                        rex in
                    })
            let json2 = JsonFormat.setNotificationToken(
                token: defaults.getNotificationToken()!,
                category: "nhancebackground")
                .format()
            DatabaseDelegate.performRequest(
                with: json2,
                ret: returnType.string,
                completion:
                    {
                        rex in
                    })
        }else if defaults.getApplicationType() == .PeakClients(.any){
            let json = JsonFormat.setNotificationToken(
                token: defaults.getNotificationToken()!,
                category: "peak"+defaults.franchiseId()!)
                .format()
            DatabaseDelegate.performRequest(
                with: json,
                ret: returnType.string,
                completion:
                    {
                        rex in
                    })
        }
    }
    
    static func resendCode(code: String, contact: String, completion: @escaping (Any) -> Void){
        let json: [String: Any] = JsonFormat.resendTwoFactor(contact: contact, code: code).format()
        DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func getUserForLogin(email: String, completion: @escaping (Any) -> Void){
        let json: [String: Any] =
            JsonFormat.getUserFromEmail(email: email)
            .format()
        DatabaseDelegate.performRequest(
            with: json,
            ret: returnType.franchiseList,
            completion:
                {
                    rex in
                    completion(rex)
                })
    }
    
    static func sendImages(images: [UIImage], taskId: String, completion: @escaping (Any) -> Void){
        let encodedImages = images.map({$0.toBase64() ?? "nil"})
        for imageStr in encodedImages{
            let json = JsonFormat.sendImagesforTask(taskId: taskId, imageData: imageStr).format()
            DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
                _ in
                //
            })
        }
    }
    
    static func getUserForms(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients(.any) {
            let json = JsonFormat.getForms(visability: "peak").format()
            DatabaseDelegate.performRequest(with: json, ret: .form, completion: {
                rex in
                completion(rex)
            })
        }else if defaults.getApplicationType() == .NHanceConnect{
            let json = JsonFormat.getForms(visability: "nhance").format()
            DatabaseDelegate.performRequest(with: json, ret: .form, completion: {
                rex in
                completion(rex)
            })
        }
    }
    
    static func getAdminForms(completion: @escaping (Any) -> Void){
        let json = JsonFormat.getForms(visability: "admin").format()
        DatabaseDelegate.performRequest(with: json, ret: .form, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func submitListOfElements(elements: [AutoFormElement], formId: String, completion: @escaping (Any) -> Void){
        var completed = 0
        for element in elements {
            let json = JsonFormat.submitFormElement(
                formID: formId,
                label: element.label,
                prompt: element.prompt,
                input: element.input)
                .format()
            performRequest(with: json, ret: .string, completion: {
                _ in
                completed += 1
                if completed == elements.count {
                    completion("done")
                }
            })
        }
    }
    
    static func submitNewFormType(form: AutoForm, completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients(.any) {
            let json = JsonFormat.submitForm(title: form.title, subtitle: form.subtitle, visability: form.vis).format()
            performRequest(with: json, ret: .string, completion: {
                rex in
                let formID = (rex as! String).replacingOccurrences(of: "\r\n", with: "")
                submitListOfElements(elements: form.elements, formId: formID, completion: {
                    rex in
                    completion(rex)
                })
            })
        }
    }
    
    static func getProfiles(completion: @escaping (Any) -> Void){
        let json = JsonFormat.getProfiles.format()
        DatabaseDelegate.performRequest(with: json, ret: .franchiseList, completion: {
            rex in
            completion(rex)
        })
    }
    
    static func getSEORankings(completion: @escaping (Any) -> Void){
        //TODO: changed the way SEO stored 07/07/2021
//        var url = defaults.franchiseURL() ?? ""
//        if defaults.getApplicationType() == .NHanceConnect{
//            url = url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "https:www.nhance.com", with: "")
//        }
//
//        let json = JsonFormat.getSEORankings(url: url).format()
//
//        DatabaseDelegate.performSEORequest(with: json, ret: .searchRank){
//            rex in
//            completion(rex)
//        }
    }
    
    static func setSEORankings(keyword: String, mapRanking: Int, organicRanking: Int, latitude: Double, longitude: Double){
        
        if defaults.getApplicationType() == .NHanceConnect{
            let json = JsonFormat.setSEORank(keyword: keyword, latitude: latitude, longitude: longitude, organicRank: organicRanking, mapsRank: mapRanking).format()
            DatabaseDelegate.performRequest(with: json, ret: .string, completion: { _ in
                //SEO Rank Submitted
            })
        }else{
            //TODO: changed the way SEO is stored on 07/07/2021
            var site = ""
            var url = defaults.franchiseURL() ?? ""
            if defaults.admin {
                url = "admin test"
            }else if defaults.getApplicationType() == .NHanceConnect{
                site = "nhance"
                url = url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "https:www.nhance.com", with: "")
            }else if defaults.getApplicationType() == .PeakClients(.admin){
                site = "peak"
            }else if defaults.getApplicationType() == .PeakClients(.chemdry){
                site = "peakchem"
            }else if defaults.getApplicationType() == .ChemDryConnect{
                site = "chemdry"
            }
            let json = JsonFormat.setSEORankings(url: url, keyword: keyword, mapRanking: String.fromInt(mapRanking)!, organicRanking: String.fromInt(organicRanking)!, site: site).format()
            
            DatabaseDelegate.performSEORequest(with: json, ret: returnType.string){
                rex in
                //
            }
        }
    }
    
    static func getAnalytics(for type: AnalyticsType_general, completion: @escaping (Any) -> Void){
        
        var json : [String: Any] = [:]
        
        var url = defaults.franchiseURL() ?? ""
        if defaults.getApplicationType() == .NHanceConnect{
            url = url.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "https:www.nhance.com", with: "")
        }
        
        switch type{
        case .Day:
            json = JsonFormat.getDashboardAnalytics(url: url).format()
        case .Week:
            json = JsonFormat.getWeekAnalytics(url: url).format()
        case .Month:
            json = JsonFormat.getMonthAnalytics(url: url).format()
        default: // .Year
            json = JsonFormat.getYearAnalytics(url: url).format()
        }
        
        DatabaseDelegate.performRequest(with: json, ret: returnType.analytics, completion: {
            rex in
            completion(rex)
        })
    }
    
    
    static func getDashboardMessage(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients(.any){
            let json = JsonFormat.getDashboardMessage(url: "").format()
            DatabaseDelegate.performRequest(with: json, ret: returnType.dashboardMessage, completion: {
                rex in
                completion(rex)//
            })
        }else if defaults.getApplicationType() == .NHanceConnect {
            var url = (defaults.franchiseURL() ?? "").replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "https:www.nhance.com", with: "")
            if defaults.admin && !defaults.urlChanged{
                url = ""
            }
            let json = JsonFormat.getDashboardMessage(url: url).format()
            DatabaseDelegate.performRequest(with: json, ret: returnType.dashboardMessage, completion: {
                rex in
                completion(rex)
            })
        }
    }
    
    static func getOpenLeads(completion: @escaping (Any) -> Void){
        let json_new = JsonFormat.getLeads_nhance(type: "open", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_new, ret: returnType.leads, completion: { rex in
           completion(rex)
        })
    }
    
    static func getAcceptedLeads(completion: @escaping (Any) -> Void){
        let json_acc = JsonFormat.getLeads_nhance(type: "accepted", id: defaults.franchiseId()!).format()
        DatabaseDelegate.performRequest(with: json_acc, ret: returnType.leads, completion: { rex in
            completion(rex)
        })
    }
    
    static func getScheduledLeads(completion: @escaping (Any) -> Void){
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
    
    static func updatePeakLeads(id: String, state: String, woo: Bool = false, completion: @escaping (Any) -> Void){
        
        var json : [String : Any] = [:]
        if !woo {
            json = JsonFormat.updateLeads_peak(id: id, state: state).format()
        }else{
            json = JsonFormat.updateLeads_woo(id: id, state: state).format()
        }
        DatabaseDelegate.performRequest(with: json, ret: returnType.string, completion: {
            rex in
            completion(rex)
        })
        
    }
    
    static func updateTask(taskId: String, taskStatus: TaskStatus, taskAssignment: String, completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients(.any){
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateformatter.string(from: Date())
            let json = JsonFormat.updateTaskStatus(taskId: taskId, status: taskStatus.rawValue, assignment: taskAssignment, date: date).format()
            DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
                _ in
                completion("done")
            })
        }else{
            
        }
    }
    
    //order of ids and name have to be equal
    static func sendTask(manager: FranchiseSelectionManager, formName: String, taskInfo: String, completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients(.any){
            if defaults.admin {
                var tempIds = manager.ids
                var tempNames = manager.ids.map({manager.getFranchiseName(for: $0)})
                if tempIds.count == 0 {
                    tempIds = [defaults.franchiseId() ?? "1"]
                    tempNames = [defaults.franchiseName() ?? "admin"]
                }
                for index in 0..<tempIds.count {
                    let id = tempIds[index]
                    let name = tempNames[index]
                    let taskString = "[\(formName):\(name)]" + taskInfo
                    let json = JsonFormat.setTask(id: id, value: taskString).format()
                    DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
                        rex in
                        completion(rex) //rex is the task ID
                    })
                }
                
            }else{
                let json = JsonFormat.setTask(id: defaults.franchiseId()!, value: taskInfo).format()
                DatabaseDelegate.performRequest(with: json, ret: .string, completion: {
                    rex in
                    completion(rex) //rex is the task ID
                })
            }
        }else{
            
        }
    }
    
    static func getTasks(completion: @escaping (Any) -> Void){
        if defaults.getApplicationType() == .PeakClients(.any){
            let json = JsonFormat.getTasks(id: defaults.franchiseId()!).format()
            //perform data base request
            DatabaseDelegate.performRequest(with: json, ret: returnType.taskList, completion: {
                    rex in
                    completion(rex)
            })
        }else if defaults.getApplicationType() == .NHanceConnect {
            //NHance Connect App does not use tasks
        }else{
            //Application Type not set, could not get Tasks
        }
    }
    
    static func getRatings(completion: @escaping (Any) -> Void){
        //ratings not set up yet
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
    
    //the seo url for all seo calls
    static var seo_url = "https://psgrank.wpengine.com/"
    
    //URL for apphook used for wordpress requests
    static private var str_url : String? = nil
    
    static func setURL(_ url: String){
        str_url = url
    }
    
    static func performSEORequest(with: [String: Any], ret: returnType, completion: @escaping (Any) -> Void){
        performRequest(with: with, ret: ret, replacementURL: seo_url, completion: completion)
    }
    
    /**
            #performRequest
     - Parameter with: json style Dictionary that gets passed to the hook (you can format this using the JsonFormat type)
     - Parameter return: what type to expect back from the db
     - Parameter completion: function that gets called upon completion of the call
     
            in order to run this function you need to have called DatabaseDelegate.setURL
     */
    static func performRequest(with: [String: Any], ret: returnType, replacementURL: String? = nil, completion: @escaping (Any) -> Void){
        
        //MARK: performRequest
        
        //if there is a replacement url
        let tempurl : String? = replacementURL != nil ? replacementURL : str_url
        
        //check that url isn't nil
        if tempurl == nil {
            fatalError("The URL for the Database Delegate is empty. Please provide a URL for the data or the app is pointless. To do this you can call DatabaseDelegate.setURL")
        }
        
        //convert string to URL. Doesn't need error handling because it's constant
        guard let url = URL(string: tempurl!) else {
            return
        }
        //http request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //convert dictionary input to json data
        let json: [String: Any] = with
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        //printr(json)

        //open URL session with the request
        URLSession.shared.dataTask(with: request) { data, response, dberror in
            do{
                //check for errors in database connection
                if (dberror != nil) { throw DataError.badHook }
                //check for no data response
                guard let d = data else { throw DataError.nilResponse }
                //data base responses can be filtered for with ^
                //printr(String.init(data: d, encoding: .ascii) ?? DataError.badFormat.rawValue, tag: printTags.database )
                //Convert data to readable response
                let rex = try objectFrom(data: d, type: ret)
                
                //send a notification that a database process has finished
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "database"), object: rex))
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
        case returnType.form:
            rex = try? JSONDecoder().decode([AutoForm].self, from: data)
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
        case returnType.searchRank:
            rex = try? JSONDecoder().decode([SearchRankingforTime].self, from: data)
        case returnType.appointmentTimeSlot:
            rex = try? JSONDecoder().decode([appointmentTimeSlot].self, from: data)
        case returnType.appointment:
            rex = try? JSONDecoder().decode([Appointment].self, from: data)
        case returnType.grouptag:
            rex = try? JSONDecoder().decode([franchiseGroupTag].self, from: data)
        case returnType.adminProfileList:
            rex = try? JSONDecoder().decode([adminProfiles].self, from: data)
        default:
            rex = String.init(data: data, encoding: .ascii)!
        }
        
        //printr(String.init(data: data, encoding: .ascii)!)
        //rex cannot be nil from the data base
        guard rex != nil else { throw DataError.nilResponse }
        return rex!
    }
}
