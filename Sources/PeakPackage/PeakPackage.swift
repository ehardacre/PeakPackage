
import SwiftUI
import UIKit

public struct PeakApp {
    
    public struct ColorScheme{
        
        @State var main : Color?
        @State var darkAccent : Color?
        @State var lightAccent : Color?
        @State var mid : Color?
        
        init(main: Color? = nil, darkAccent : Color? = nil, lightAccent : Color? = nil, mid : Color? = nil){
            self.main = main
            self.darkAccent = darkAccent
            self.lightAccent = lightAccent
            self.mid = mid
        }
        
        
    }

    public struct ImageSet{
        
        @State var logo : UIImage?
        @State var banner : UIImage?
        
        init(logo : UIImage? = nil, banner : UIImage? = nil){
            self.logo = logo
            self.banner = banner
        }
        
    }
    
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
    public static func constructScene(type: ApplicationType?, colorScheme : ColorScheme? = nil, imageSet : ImageSet? = nil) -> some Scene{
        
        if colorScheme != nil {
            setColorScheme(main: colorScheme?.main, darkAccent: colorScheme?.darkAccent, lightAccent: colorScheme?.lightAccent, mid: colorScheme?.mid)
        }
        
        if imageSet != nil {
            setImageSet(logo: imageSet?.logo, banner: imageSet?.banner)
        }
        
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
    public static func setColorScheme(main: Color? = nil, darkAccent: Color? = nil, lightAccent: Color? = nil, mid: Color? = nil){
        
        Color.setColorScheme(main, darkAccent, lightAccent, mid)
        
    }
    
    /**
    #SET Image Set
     the banner and logo image for the app
     */
    public static func setImageSet(logo: UIImage? = nil, banner: UIImage? = nil){
        if logo != nil{
            defaults.logo = logo!
        }
        if banner != nil{
            defaults.banner = banner!
        }
    }
    
}
