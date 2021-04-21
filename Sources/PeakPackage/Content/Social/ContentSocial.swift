//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 4/21/21.
//

import Foundation
import SwiftUI

public struct Content_Social : PublicFacingContent {
    
    @ObservedObject var manager : Manager
    
    public init(manager: Manager){
        self.manager = manager
    }
    
    public var body : some View {
        EmptyView()
    }
    
}
