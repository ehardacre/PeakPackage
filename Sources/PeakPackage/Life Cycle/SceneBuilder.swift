//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/21/21.
//

import Foundation
import SwiftUI

public struct SceneConstruct : Scene{
    
    @State var content : AnyView
    
    @SceneBuilder public var body: some Scene{
        WindowGroup{
            MotherView(content: content)
                //.environmentObject(ViewRouter())
        }
    }
    
}
