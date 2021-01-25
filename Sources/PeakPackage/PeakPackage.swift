
import SwiftUI
import UIKit

public struct PeakApp {
    
    /**
    #GET App Delegate
     returns the app delegate class that sets up the app for our clients
     */
    public static func getAppDelegate() -> AppDelegate.Type{
        return AppDelegate.self
    }
    
    /**
     #Construct Scene
     constructs the scene based on the app type
     make sure you call the setAppType function before running
     */
    public static func constructScene(type: ApplicationType?) -> some Scene{
        
        if type != nil{
            defaults.setApplicationType(type!)
        }
        
        do {
            
            _ = try defaults.getApplicationType()
            return SceneConstruct()
            
        }catch{
            printr(error, tag: IncompleteSetupError.applicationType.rawValue)
            return SceneConstruct(blank: true)
        }
    }
    
    /**
    #SET App Type
     set's the type of the app such as Peak Clients, or N-Hance Connect
     */
    public static func setAppType(_ type : ApplicationType){
        defaults.setApplicationType(type)
    }
    
    /**
     #SET Color Scheme
        sets the color scheme for the app
     */
    public static func setColorScheme(main: Color?, darkAccent: Color?, lightAccent: Color?, mid: Color?){
        
        Color.setColorScheme(main, darkAccent, lightAccent, mid)
        
    }
    
    /**
    #SET Image Set
     the banner and logo image for the app
     */
    public static func setImageSet(logo: UIImage, banner: UIImage){
        
    }
    
}
