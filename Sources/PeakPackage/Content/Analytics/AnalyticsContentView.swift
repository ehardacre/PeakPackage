//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 2/17/21.
//

import Foundation
import SwiftUI

public struct Content_Analytics_multiPage : PublicFacingContent{
    
    @ObservedObject public var manager: Manager
    //the index for analytics page: week month or year
    @State public var analyticsIndex = 2
    
    //required to set manager
    public init(manager: Manager) {
        self.manager = manager
    }
    
    public var body : some View {
        ZStack{
            switch analyticsIndex{
            case 0:
                AnalyticsView(
                    type: AnalyticsType.thisYear,
                    analyticsMan: manager as! AnalyticsManager)
            case 1:
                AnalyticsView(
                    type: AnalyticsType.thisMonth,
                    analyticsMan: manager as! AnalyticsManager)
            case 2:
                AnalyticsView(
                    type: AnalyticsType.thisWeek,
                    analyticsMan: manager as! AnalyticsManager)
                    .onAppear{
                        //load month and year when week is opened
                        (manager as! AnalyticsManager)
                            .loadAnalytics(for: .Month)
                        (manager as! AnalyticsManager)
                            .loadAnalytics(for: .Year)
                    }
            default:
                //should never be called
                EmptyView().onAppear{ fatalError() }
            }
            
            VStack{
                
                Spacer()
                PageControl(
                    index: $analyticsIndex,
                    maxIndex: AnalyticsManager.pages.count - 1,
                    pageNames: AnalyticsManager.pages,
                    dividers: true)
                
            }
        }
    }
}
