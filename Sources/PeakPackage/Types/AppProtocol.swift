//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/16/21.
//

import Foundation
import SwiftUI

//a protocol for defining app layouts without having them hard coded into the framework
open class AppLayout {
    
    var AnalyticsView_exists = false
    var CalendarView_exists = false
    var DashboardView_exists = false
    var TasksView_exists = false
    var LeadsView_exists = false
    
    public init(){}
    
    //each app layout must define the following
    open func AnalyticsView(manager: Manager?) -> AnyView? {
        fatalError("Must Override")
    }
    open func AnalyticsView(manager: Manager?, @ViewBuilder content: @escaping () -> AnyView) -> AnyView? {
        if manager == nil {
            return nil
        }else{
            AnalyticsView_exists = true
            return AnyView(content())
        }
    }
    
    open func CalendarView(manager: Manager?) -> AnyView? {
        fatalError("Must Override")
    }
    open func CalendarView(manager: Manager?, @ViewBuilder content: @escaping () -> AnyView) -> AnyView? {
        if manager == nil {
            return nil
        }else{
            CalendarView_exists = true
            return AnyView(content())
        }
    }
    
    open func DashboardView(manager: Manager?) -> AnyView? {
        fatalError("Must Override")
    }
    open func DashboardView(manager: Manager?, @ViewBuilder content: @escaping () -> AnyView) -> AnyView? {
        if manager == nil {
            return nil
        }else{
            DashboardView_exists = true
            return AnyView(content())
        }
    }
    
    open func TasksView(manager: Manager?) -> AnyView? {
        fatalError("Must Override")
    }
    open func TasksView(manager: Manager?, @ViewBuilder content: @escaping () -> AnyView) -> AnyView? {
        if manager == nil {
            return nil
        }else{
            TasksView_exists = true
            return AnyView(content())
        }
    }
    
    open func LeadsView(manager: Manager?) -> AnyView? {
        fatalError("Must Override")
    }
    open func LeadsView(manager: Manager?, @ViewBuilder content: @escaping () -> AnyView) -> AnyView? {
        if manager == nil {
            return nil
        }else{
            LeadsView_exists = true
            return AnyView(content())
        }
    }
    
}

//class Peak : AppLayout {
//    override func AnalyticsView(manager: Manager?) -> AnyView? {
//        return super.AnalyticsView(manager: manager){
//            AnyView{
//                Content_Analytics_multiPage(manager: manager!)
//            }!
//        }
//    }
//    
//    override func CalendarView(manager: Manager?) -> AnyView? {
//        return super.CalendarView(manager: manager){
//            AnyView{
//                Content_Calendar(manager: manager!)
//            }!
//        }
//    }
//    
//    override func DashboardView(manager: Manager?) -> AnyView? {
//        return super.DashboardView(manager: manager){
//            AnyView{
//                Content_Calendar(manager: manager!)
//            }!
//        }
//    }
//    
//    override func TasksView(manager: Manager?) -> AnyView? {
//        return super.DashboardView(manager: manager){
//            AnyView{
//                Content_Tasks(manager: manager!)
//            }!
//        }
//    }
//    
//    override func LeadsView(manager: Manager?) -> AnyView? {
//        return super.LeadsView(manager: manager){
//            AnyView{
//                Content_Leads_multiPage(manager: manager!)
//            }!
//        }
//    }
//    
//    
//}
