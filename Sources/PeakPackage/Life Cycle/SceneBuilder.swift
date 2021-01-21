//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/21/21.
//

import Foundation
import SwiftUI

struct SceneConstruct : Scene{
    
    @SceneBuilder var body: some Scene{
        WindowGroup{
            ContentView().environmentObject(ViewRouter())
        }
    }
    
}
