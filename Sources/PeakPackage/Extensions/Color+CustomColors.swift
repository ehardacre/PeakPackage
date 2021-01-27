// Kevin Li - 2:46 PM - 6/1/20

import SwiftUI

extension Color {

    static let systemBackground = Color(UIColor.systemBackground)
    
}


//MARK: Color Defaults
/**
 #Color Set
 The colors for this app
 */

//extension Color {
//
//    static let b_or_w = Color("B+W")
//    static let main = Color("NHanceOrange")
//    static let darkAccent = Color("NHanceDark")
//    static let lightAccent = Color("NHanceLight")
//    static let neutral = Color("NHanceMid")
//    static let mid = Color("NHanceMid")
//
//    static let b_or_wUI = UIColor(named: "B+W")
//    static let mainUI = UIColor(named: "NHanceOrange")
//    static let darkAccentUI = UIColor(named: "NHanceDark")
//    static let lightAccentUI = UIColor(named: "NHanceLight")
//    static let neutralUI = UIColor(named: "NHanceMid")
//    static let midUI = UIColor(named: "NHanceMid")
//
//}

extension Color {
    
    public static var b_or_w = defaults.SourceColor(named: "base")!
    public static var main = defaults.SourceColor(named: "main")!
    public static var darkAccent = defaults.SourceColor(named: "dark")!
    public static var lightAccent = defaults.SourceColor(named: "light")!
    public static var mid = defaults.SourceColor(named: "mid")!
    
    public static var b_or_wUI = UIColor(b_or_w)
    public static var mainUI = UIColor(main)
    public static var darkAccentUI = UIColor(darkAccent)
    public static var lightAccentUI = UIColor(lightAccent)
    public static var midUI = UIColor(mid)
    
    public static func setColorScheme(_ main: Color?, _ darkAccent: Color?, _ lightAccent: Color?, _ mid: Color?){
        
        if main != nil {
            self.main = main!
            self.mainUI = UIColor(main!)
        }
        
        if darkAccent != nil {
            self.darkAccent = darkAccent!
            self.darkAccentUI = UIColor(darkAccent!)
        }
        
        if lightAccent != nil {
            self.lightAccent = lightAccent!
            self.lightAccentUI = UIColor(lightAccent!)
        }
        
        if mid != nil {
            self.mid = mid!
            self.midUI = UIColor(mid!)
        }
        
    }
    
}
