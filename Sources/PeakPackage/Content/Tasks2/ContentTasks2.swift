//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI

public struct Content_Tasks2: PublicFacingContent {
    
    @ObservedObject public var manager: Manager
    
    
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body: some View {
        TaskHeaderView(taskManager: manager as! TaskManager2)
    }
}

struct Content_Tasks2_Previews: PreviewProvider {
    static var previews: some View {
        Content_Tasks2(manager: TaskManager2())
    }
}
