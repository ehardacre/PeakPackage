//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/21/21.
//

import Foundation
import SwiftUI

public struct SceneConstruct : Scene{
    
    @State var blank : Bool = false
    
    @SceneBuilder public var body: some Scene{
        WindowGroup{
            if !blank {
                MotherView().environmentObject(ViewRouter())
            }
        }
    }
    
}
