
import SwiftUI
import UIKit

struct PeakPackage {
    
    
    
    func setScene(type: ApplicationType? = ApplicationType.PeakClients){
        
        defaults.setApplicationType(type)
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create the SwiftUI view that provides the window contents.
        _ = ContentView().environment(\.managedObjectContext, context)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: MotherView().environmentObject(ViewRouter()))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
}
