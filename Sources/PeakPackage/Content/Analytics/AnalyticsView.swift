//
//  AnalyticsView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/24/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import SwiftUICharts
import SwiftUIRefresh

///this is the content that is the analytics tab
extension ContentView {
    
    ///the content for the analytics tab. separated for simplicity
    func AnalyticsContent() -> some View {
        ZStack{
            
            switch analyticsIndex{
            
            case 0:
                AnalyticsView(type: AnalyticsType.thisYear, analyticsMan: analyticsManager).onAppear{
                    analyticsManager.loadAnalytics(for: .Year)
                }
            case 1:
                AnalyticsView(type: AnalyticsType.thisMonth, analyticsMan: analyticsManager).onAppear{
                    analyticsManager.loadAnalytics(for: .Month)
                }
            case 2:
                AnalyticsView(type: AnalyticsType.thisWeek, analyticsMan: analyticsManager).onAppear{
                    analyticsManager.loadAnalytics(for: .Week)
                }
            default:
                EmptyView()
            }
            
            
            VStack{
                
                Spacer()
                
                PageControl(index: $analyticsIndex, maxIndex: AnalyticsManager.pages.count - 1, pageNames: AnalyticsManager.pages, dividers: true)
                
            }
        }
    }
    
}

/**
 #Analytics View
 the view that is used for each of the analytics pages
 - Parameter type : the analytics type to be shown
 - Parameter analyticsMan : the analytics manager that will manage the data
 */
struct AnalyticsView: View {
    
    //the type of analytics being shown
    var type : AnalyticsType
    
    //the analytics manager
    @ObservedObject var analyticsMan : AnalyticsManager
    
    @ObservedObject var ppc_text_values : Comparisons = Comparisons()
    @ObservedObject var page_text_values : Comparisons = Comparisons()
    
    @State var refreshing = false
    
    var body: some View {
        
        VStack{
            
            NavigationView{
                
                List{
                    
                    VStack(alignment: .leading){
                        if type == AnalyticsType.thisWeek {
                            Text(analyticsMan.subtitleForWeek()).font(.footnote).bold().foregroundColor(.darkAccent)
                            Text(analyticsMan.subnoteForWeek()).font(.footnote).foregroundColor(Color.darkAccent.opacity(0.5))
                        }else if type == AnalyticsType.thisMonth {
                            Text(analyticsMan.subtitleForMonth()).font(.footnote).bold().foregroundColor(.darkAccent)
                            Text(analyticsMan.subnoteForMonth()).font(.footnote).foregroundColor(Color.darkAccent.opacity(0.5))
                        }else{
                            Text(analyticsMan.subtitleForYear()).font(.footnote).bold().foregroundColor(.darkAccent)
                            Text(analyticsMan.subnoteForYear()).font(.footnote).foregroundColor(Color.darkAccent.opacity(0.5))
                        }
                    }
                    
                    //the page analytics view
                    //AnalyticsInfoView(type: type, analyticsMan: analyticsMan, page: true){}
                    //.listRowBackground(Color.clear)
                    
                    //the ppc analytics view
                    //AnalyticsInfoView(type: type, analyticsMan: analyticsMan, page: false){}
                    //.listRowBackground(Color.clear)
                    
                    PageAnalyticsInfoView(type: type, analyticsMan: analyticsMan, values: page_text_values)
                    PPCAnalyticsInfoView(type: type, analyticsMan: analyticsMan values: ppc_text_values)
                    
                    Spacer(minLength: 50)
                    
                }
                .listStyle(SidebarListStyle())
                .navigationBarTitle(type.displayName(full: true))
                .background(Color.clear)
            }.pullToRefresh(isShowing: $refreshing){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //analyticsMan.loadAnalytics()
                    self.refreshing = false
                }
            }
        }
        .stackOnlyNavigationView()
    }
}

