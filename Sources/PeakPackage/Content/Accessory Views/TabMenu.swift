//
//  TabMenu.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/30/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

///Specific tab menu for the content of the Peak Clients app
public struct TabMenu : View {
    
    @Binding var tab : tabs
    @Binding var availableTabs : [tabs]
    var notificationCount : Int
    
    
    //rectangle.stack.person.crop.fill, magnifyingglass.circle.fill, chart.bar.fill
    let images : [tabs : String] =
        [ tabs.analytics : "chart.bar.fill", tabs.calendar : "calendar", tabs.leads : "rectangle.stack.person.crop.fill", tabs.seo : "person.crop.square.fill.and.at.rectangle", tabs.tasks : "list.dash"]
    
    public var body : some View{
        HStack{
            
            ForEach(availableTabs, id: \.rawValue){ t in
                if t == tabs.dashboard{
                    //Dashboard button
                    Button(action: { self.tab = tabs.dashboard }){
                        Image(uiImage: defaults.logo).tabCenter_style()
                    }.tabCenter_style()
                }else{
                    Spacer(minLength: 0)
                    tabButton(imageName: images[t]!, globalTab: $tab, myTab: t)
                    Spacer(minLength: 0)
                }
            }
            
//            Spacer(minLength: 0)
//
//            tabButton(imageName: "rectangle.stack.person.crop.fill", globalTab: $tab, myTab: tabs.leads, notificationCount: notificationCount)
            
            
        //HSTACK end
        }.padding(.horizontal, 35)
        .background(Color.lightAccent.edgesIgnoringSafeArea(.all)) //lets the view continue into the bottom safe area
    }
}

///a button for the tab bar
public struct tabButton : View {
    
    var imageName : String
    // the tab selected
    @Binding var globalTab : tabs
    // the tab of this button
    var myTab : tabs
    var notificationCount : Int = 0

    public var body: some View {
        Button(action: { self.globalTab = myTab }){
            Image(systemName: imageName).tab_style().overlay(NotificationNumLabel(number: notificationCount))
        }
        .tab_style(selected: self.globalTab == myTab)
    }
}

extension Button {
    ///the style modifier for a default tab button
    func tab_style(selected: Bool) -> some View{
        return self
            .padding(23)
            .foregroundColor(Color.darkAccent.opacity(selected ? 1 : 0.2))
    }
    ///the style modifier for the tab button that goes at the center
    func tabCenter_style() -> some View{
        return self
            .offset( y: -25)
    }
}

extension Image {
    ///the style modifier for  a tab image
    func tab_style() -> some View {
        return self
            .resizable()
            .imageScale(.large)
            .scaledToFit()
    }
    ///the style modifier for the center image, pretty specific to peak clients logo
    func tabCenter_style() -> some View {
        return self
            .renderingMode(.original)
            .resizable()
            .frame(width:60.0, height: 60.0).background(Circle().foregroundColor(Color.lightAccent))
    }
}
