//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/25/21.
//

import Foundation
import SwiftUI
import UIKit

public class ProfileManager : Manager {
    
    @Published var profiles : [Franchise] = []
    @Published var id : String?
    
    public override init() {}
    
    func loadProfiles(){
        DatabaseDelegate.getProfiles(
            completion: {
            rex in
            self.profiles = rex as! [Franchise]
        })
    }
    
    func changeFranchise(
        to newID: String,
        newURL: String,
        newName: String){
        
        if id == newID {
            id = nil
            defaults.urlChanged = false
        }else{
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            id = newID
            defaults.setTempFranchise(newURL,newName,newID)
        }
        
        NotificationCenter.default.post(
            Notification(
                name: LocalNotificationTypes.changedProfile.postName(),
                object: id))
    }
}
