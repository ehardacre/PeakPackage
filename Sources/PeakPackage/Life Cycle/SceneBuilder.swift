//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/21/21.
//

import Foundation
import SwiftUI

public struct SceneConstruct : Scene{
    
    @SceneBuilder public var body: some Scene{
        WindowGroup{
            MotherView().environmentObject(ViewRouter())
        }
    }
    
}
