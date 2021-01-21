//
//  DatabaseDelegate.swift
//  Peak Client
//
//  Created by Ethan Hardacre  on 7/7/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import Foundation
import SwiftUI

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
