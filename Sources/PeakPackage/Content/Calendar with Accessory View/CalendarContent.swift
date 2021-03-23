//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 2/17/21.
//

import SwiftUI

/**
 #Content_Calendar
 Content for the calendar view 
 */
public struct Content_Calendar: PublicFacingContent{
    
    @ObservedObject public var manager: Manager
    
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        CallCalendarView(ascVisits: (manager as! AppointmentManager).appointments)
    }
}

