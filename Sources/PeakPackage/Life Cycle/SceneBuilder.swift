//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/21/21.
//

import Foundation
import SwiftUI

public struct SceneConstruct : Scene{
    
    @State var motherView : MotherView? = nil
    
    @SceneBuilder public var body: some Scene{
        WindowGroup{
            if motherView != nil{
                motherView
            }
        }
    }
    
}
