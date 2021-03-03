//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/25/21.
//

import Foundation

public class ProfileManager : Manager {
    
    @Published var profiles : [Franchise] = []
    @Published var id : String?
    
    public override init() {}
    
    func loadProfiles(){
        DatabaseDelegate.getProfiles(completion: {
            rex in
            self.profiles = rex as! [Franchise]
        })
    }
}
