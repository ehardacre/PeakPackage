//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/17/21.
//

import SwiftUI

public struct Content_Calendar: PublicFacingContent{
    
    @ObservedObject public var manager: Manager
    
    init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        CallCalendarView(ascVisits: (manager as! AppointmentManager).appointments)
    }
}

