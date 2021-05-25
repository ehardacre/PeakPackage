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

public enum ApplicationType : Equatable{
    case PeakClients(ClientTypes = ClientTypes.any)
    public enum ClientTypes {
        case any
        case admin
        case chemdry
        case unspilt
    }
    case NHanceConnect
    case ChemDryConnect
    
    public static func ==(l: ApplicationType, r: ApplicationType) -> Bool{
        switch (l,r){
        case (.PeakClients(.any), .PeakClients(.any)):
            return true
        case (.PeakClients(.any), .PeakClients(.admin)):
            return true
        case (.PeakClients(.any), .PeakClients(.chemdry)):
            return true
        case (.PeakClients(.any), .PeakClients(.unspilt)):
            return true
        case (.PeakClients(.admin), .PeakClients(.any)):
            return true
        case (.PeakClients(.chemdry), .PeakClients(.any)):
            return true
        case (.PeakClients(.unspilt), .PeakClients(.any)):
            return true
        case (.PeakClients(.admin), .PeakClients(.admin)):
            return true
        case (.PeakClients(.chemdry), .PeakClients(.chemdry)):
            return true
        case (.PeakClients(.unspilt), .PeakClients(.unspilt)):
            return true
        case (.NHanceConnect, .NHanceConnect):
            return true
        case (.ChemDryConnect, .ChemDryConnect):
            return true
        default:
            return false
        }
    }
}

//MARK: User Defaults
/**
 # Defaults
 used as a manager for user defaults so that keys for user defaults don"t have to be remembered
 */
struct defaults {
    
    //MARK: Stored Values for All
    
    private static var application : ApplicationType? = nil
    private static var tempAppType : ApplicationType? = nil
    //these are the print logs stored for viewing by admin for debugging
    private static var logs = [String]()
    private static var loaded = false
    //the code that is expected by two-factor authentication
    static var expectedCode = ""
    //admin variables
    static let admin_id = "1"
    static var admin = false
    //The image assets needed for the app
    static var banner : UIImage = SourceImage(named: "banner")!
    static var logo : UIImage = SourceImage(named: "logo")!
    static var loginWithUsername = false
    
    //MARK: Stored Values for Peak Clients
    
    //key values for user defaults queries
    private static let notificationToken_key = "notificationToken"
    private static let signIn_key = "signedIn"
    private static let username_key = "username"
    private static let franchise_key = "franchiseID"
    private static let url_key = "franchiseURL"
    private static let location_key = "franchiseLoc"
    private static let temp_location_key = "tempLoc"
    private static let temp_url_key = "tempURL"
    private static let temp_name_key = "tempName"
    private static let temp_id_key = "tempId"
    static var urlChanged = false
    private static let name_key = "franchiseName"
    private static let email_key = "email"
    private static let phone_key = "phone"
    //woocommerce
    static let woocommerce_id = "46"
    static var woocommerce = false
    
    //MARK: Getters
    
    public static func SourceImage(named name: String) -> UIImage? {
      UIImage(named: name, in: Bundle.module, compatibleWith: nil)
    }
    
    public static func SourceColor(named name: String) -> Color? {
        Color(name, bundle: Bundle.module)
    }
    
    static func getApplicationType() -> ApplicationType {
        if self.application == nil {
            fatalError("Application Type must be set")
        }
        var app = application!
        if urlChanged {
            app = tempAppType ?? application!
        }
        return app
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
        let url = defaults.franchiseURL()
        var mainTopic = "unregistered"
        if url != nil{
            mainTopic = url!.replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: ".com", with: "")
            mainTopic = mainTopic.trimmingCharacters(in: CharacterSet.init(charactersIn: "/."))
        }
        return mainTopic
    }
    
    static func franchiseURL() -> String?{
        var url : String?
        if urlChanged{
            url = UserDefaults.standard.string(forKey: temp_url_key)
        }else{
            url = UserDefaults.standard.string(forKey: url_key)
        }
        return url
    }
    
    static func getUsername() -> String?{
        return UserDefaults.standard.string(forKey: username_key)
    }
    
    static func franchiseLocationforSEO() -> String?{
        var location : String?
        if urlChanged{
            location = UserDefaults.standard.string(forKey: temp_location_key)
        }else{
            location = UserDefaults.standard.string(forKey: location_key)
        }
        return location
    }
    
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
        if urlChanged {
            return UserDefaults.standard.string(forKey: temp_id_key)
        }
        return UserDefaults.standard.string(forKey: franchise_key)
    }
    
    static func franchiseName() -> String? {
        var name : String?
        if urlChanged{
            name = UserDefaults.standard.string(forKey: temp_name_key)
        }else{
            name = UserDefaults.standard.string(forKey: name_key)
        }
        return name
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
            DatabaseDelegate.setURL("https://clients.peakstudios.com/peak-clients-api-v2/")
        case .NHanceConnect:
            DatabaseDelegate.setURL("https://www.nhance.com/peak-studios-api/")
        default:
            return
        }
    }
    
    static func setFranchiseURL(_ url: String){UserDefaults.standard.set(url, forKey: url_key)}
    static func setTempFranchise(_ url: String, _ name: String, _ id: String){
        if admin{
            urlChanged = true
            UserDefaults.standard.set(url, forKey: temp_url_key)
            UserDefaults.standard.set(name, forKey: temp_name_key)
            UserDefaults.standard.set(id, forKey: temp_id_key)
            if name.contains("Chem-Dry"){
                tempAppType = .PeakClients(.chemdry)
            }
        }
    }
    
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
        if value == admin_id && application == .PeakClients(.any) {
            application = .PeakClients(.admin)
            admin = true
        }else if value == woocommerce_id && application == .PeakClients(.any) {
            application = .PeakClients(.unspilt)
            woocommerce = true
        }
    }

    static func franchiseName(value: String){
        UserDefaults.standard.set(value, forKey: name_key)
        if value.contains("Chem-Dry") && application == .PeakClients(.any){
            application = .PeakClients(.chemdry)
        }
    }
    
    static func username(value: String){
        UserDefaults.standard.set(value, forKey: username_key)
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
    
    static func username(exists: Bool) -> Bool{
        return exists && (getUsername() != nil)
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
        exit(0)
    }

    static func allSet() -> Bool {
        var all = signedIn(exists: true)
        if defaults.getApplicationType() == .NHanceConnect {
            
        }else if defaults.getApplicationType() == .PeakClients(.any) {
            all = username(exists: true) && franchiseId(exists: true) && franchiseName(exists: true)
        }else{
            return false
        }
        return all
    }
}


