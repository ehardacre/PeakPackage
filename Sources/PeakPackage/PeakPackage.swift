
import SwiftUI
import UIKit

public struct PeakApp {
    
    public static func getAppDelegate() -> AppDelegate.Type{
        return AppDelegate.self
    }
    
    public static func constructScene() -> some Scene{
        return SceneConstruct()
    }
    
}
