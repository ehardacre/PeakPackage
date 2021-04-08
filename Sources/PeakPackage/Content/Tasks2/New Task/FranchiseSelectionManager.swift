//
//  File 2.swift
//  
//
//  Created by Ethan Hardacre  on 3/25/21.
//

import Foundation

public class FranchiseSelectionManager : Manager {
    
    @Published var profiles : [Franchise] = []
    @Published var ids : [String] = []
    
    public override init() {
        
        super.init()
        loadProfiles()
        
    }
    
    func loadProfiles(){
        DatabaseDelegate.getProfiles(
            completion: {
            rex in
            self.profiles = rex as! [Franchise]
        })
    }
    
    func selectFranchise(id: String){
        if isSelectedFranchise(id: id) {
            if let index = ids.firstIndex(of: id) {
                ids.remove(at: index)
            }
        }else{
            ids.append(id)
        }
        NotificationCenter.default.post(
            Notification(
                name: Notification.Name("franchiseForTaskUpdated"),
                object: nil))
    }
    
    func isSelectedFranchise(id: String) -> Bool{
        return ids.contains(id)
    }
    
}
