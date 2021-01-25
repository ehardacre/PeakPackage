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
    
    static var b_or_w = Color("base")
    static var main = Color("main")
    static var darkAccent = Color("dark")
    static var lightAccent = Color("light")
    static var mid = Color("mid")
    
    static var b_or_wUI = UIColor(b_or_w)
    static var mainUI = UIColor(main)
    static var darkAccentUI = UIColor(darkAccent)
    static var lightAccentUI = UIColor(lightAccent)
    static var midUI = UIColor(mid)
    
    static func setColorScheme(_ main: Color?, _ darkAccent: Color?, _ lightAccent: Color?, _ mid: Color?){
        
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
