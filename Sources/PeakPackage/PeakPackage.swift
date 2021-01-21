
import SwiftUI
import UIKit

struct PeakPackage {
    
    func getAppDelegate() -> AppDelegate.Type{
        return AppDelegate.self
    }
    
    func constructScene() -> some Scene{
        return SceneConstruct()
    }
    
}
