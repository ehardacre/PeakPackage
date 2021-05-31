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
    @Published var tagManager = TagManager()
    
    public override init() {
        
        super.init()
        loadProfiles()
        tagManager.loadTags()
        
    }
    
    func loadProfiles(){
        DatabaseDelegate.getProfiles(
            completion: {
            rex in
            self.profiles = rex as! [Franchise]
                NotificationCenter.default.post(name: Notification.Name("FranchiseListLoaded"), object: rex, userInfo: nil)
        })
    }
    
    func selectFranchise(id: String){
        printr(id)
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
    
    func getFranchiseName(for id: String?) -> String {
        for fran in profiles{
            if fran.franchiseId == id {
                return fran.franchiseTitle
            }
        }
        return "admin"
    }
    
    func isSelectedFranchise(id: String) -> Bool{
        return ids.contains(id)
    }
    
}
