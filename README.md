# PeakPackage

Internal Package for Apps by Peak Studios.

## Swift Package Manager

This package can be imported using SPM by going to `File` > `Swift Packages` > `Add Package Dependency...` and entering the url for the package: `https://github.com/ehardacre/PeakPackage.git`

## Usage

import the PeakPackage in the App file and athe ContentView.swift file: `import PeakPackage`

### App File:

add these lines at the top of the App struct:
```
    @UIApplicationDelegateAdaptor(PeakApp.getAppDelegate()) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
```

and the body of the App struct: 

```
var body: some Scene {
        PeakApp.constructScene(type: ApplicationType.NHanceConnect, content: AnyView(mainContent()), before: {
            
            PeakApp.setColorScheme(main: Color("Peak"), darkAccent: Color("PeakDark"), lightAccent: Color("PeakLight"), mid: Color("PeakMid"))
            PeakApp.setImageSet(logo: UIImage(named: "peak_thumb"), banner: UIImage(named: "peakLogo_full"))
            
        })
    }
```

### ContentView.swift

First, change the name of the struct to mainContent to avoid conflicts (`struct mainContent : View`). Then, change the body to include the line to set up the content: 

```
ContentView(tabMenuOptions: [tabs.analytics, tabs.calendar, tabs.dashboard, tabs.tasks, tabs.leads, tabs.ratings])
```



