//
//  UserDefaults.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 8/25/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public enum ApplicationType {
    case PeakClients
    case NHanceConnect
}

//MARK: User Defaults
/**
 # Defaults
 used as a manager for user defaults so that keys for user defaults don"t have to be remembered
 */
struct defaults {
    
    //MARK: Stored Values for All
    
    private static var application : ApplicationType? = nil
    //these are the print logs stored for viewing by admin for debugging
    private static var logs = [String]()
    private static var loaded = false
    //the code that is expected by two-factor authentication
    static var expectedCode = ""
    //admin variables
    static let admin_id = "1"
    static var admin = false
    //The image assets needed for the app
    static var banner : UIImage = UIImage(named: "banner")
    static var logo : UIImage = UIImage(named: "logo")
    
    //MARK: Stored Values for Peak Clients
    
    //key values for user defaults queries
    private static let notificationToken_key = "notificationToken"
    private static let signIn_key = "signedIn"
    private static let username_key = "username"
    private static let franchise_key = "franchiseID"
    private static let url_key = "franchiseURL"
    private static let name_key = "franchiseName"
    private static let email_key = "email"
    private static let phone_key = "phone"
    //woocommerce
    static let woocommerce_id = "46"
    static var woocommerce = false
    
    //MARK: Getters
    
    static func getApplicationType() throws -> ApplicationType {
        if self.application == nil {
            throw IncompleteSetupError.applicationType
        }
        return self.application!
    }
    
    /**
     # Get Logs
     grabs the things that would appear in the console on xcode
     */
    static func getLogs() -> [String]{
        if !loaded{
            logAllDefaults()
        }
        return logs
    }
    
    /**
    # Get Topics
     get's the topic for this user for firebase notifications
     */
    static func getTopics() -> String{
        let url = UserDefaults.standard.string(forKey: url_key)
        var mainTopic = "unregistered"
        if url != nil{
            mainTopic = url!.replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: ".com", with: "")
            mainTopic = mainTopic.trimmingCharacters(in: CharacterSet.init(charactersIn: "/."))
        }
        return mainTopic
    }
    
    static func franchiseURL() -> String?{return UserDefaults.standard.string(forKey: url_key)}
    
    /**
    #Get Encoded Email
     encodes the users email for...? I forget, but it's important (notifications maybe)
     */
    static func getEncodedEmail()->String{
        return MD5(string: defaults.getEmail()!).base64EncodedString() + "@psclients.com"
    }
    
    static func getEmail() -> String?{
        return UserDefaults.standard.string(forKey: email_key)
    }
    
    static func getNotificationToken() -> String? {
        return UserDefaults.standard.string(forKey: notificationToken_key)
    }

    static func signedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: signIn_key)
    }
    
    static func franchiseId() -> String? {
        return UserDefaults.standard.string(forKey: franchise_key)
    }
    
    static func franchiseName() -> String? {
        return UserDefaults.standard.string(forKey: name_key)
    }
    
    //MARK: Setters
    
    /**
        #Set Application Type
     set's the type for the app. can be used to determine which client the app is for
     */
    static func setApplicationType(_ type : ApplicationType){
        application = type
        setDBURL()
    }
    private static func setDBURL(){
        switch application{
        case .PeakClients:
            DatabaseDelegate.setURL("https://clients.peakstudios.com/apphook/")
        case .NHanceConnect:
            DatabaseDelegate.setURL("https://www.nhance.com/peak-studios-api/")
        }
    }
    
    static func setFranchiseURL(_ url: String){UserDefaults.standard.set(url, forKey: url_key)}
    
    static func setEmail(_ email: String){
        UserDefaults.standard.set(email, forKey: email_key)
    }
    
    static func setNotificationToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: notificationToken_key)
    }
    
    static func signIn() {
        UserDefaults.standard.set(true, forKey: signIn_key)
    }
    
    static func franchiseId(value: String){
        UserDefaults.standard.set(value, forKey: franchise_key)
    }

    static func franchiseName(value: String){
        UserDefaults.standard.set(value, forKey: name_key)
    }
    
    //MARK: Exists Functions
    
    static func signedIn(exists: Bool) -> Bool{
        return exists && (UserDefaults.standard.string(forKey: signIn_key) != nil)
    }
    
    static func franchiseId(exists: Bool) -> Bool {
        return exists && (franchiseId() != nil)
    }

    static func franchiseName(exists: Bool) -> Bool {
        return exists && (franchiseName() != nil)
    }
    
    
    //MARK: Functions
    
    static func addToLogs(title: String = "", log : String , top: Bool = false){
        let content = title + ": " + log
        if top {
            logs.insert(content, at: 0)
        }else{
            logs.append(content)
        }
        loaded.toggle()
    }
    
    static func logAllDefaults(){
        addToLogs(title: "(UD) \(notificationToken_key)", log: getNotificationToken() ?? "", top: true)
        addToLogs(title: "(UD) \(url_key)", log: franchiseURL() ?? "", top: true)
        addToLogs(title: "(UD) \(franchise_key)", log: franchiseId() ?? "", top: true)
        addToLogs(title: "(UD) \(name_key)", log: franchiseName() ?? "", top: true)
    }
    
    /**
        #Logout
        restarts the user defaults and forces exit on the app. probably should go back to the login screen instead
     */
    static func logout() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        printr("Logging Out...")
        exit(0)
    }

    static func allSet() -> Bool {
        return signedIn(exists: true)
        //TODO: add all variables that need to be set
        #warning("TODO: add all variables that need to be set on sign in.")
    }
}


