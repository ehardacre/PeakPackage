//
//  PageControl.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/19/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

/**
 # Page Control
 the view for the small pill at the bottom of the screen that shows the user which page they are on
 */
struct PageControl: View {
    
    //indexing for updating the view
    @Binding var index: Int
    let maxIndex: Int
    
    //the names of the pages to be displayed
    var pageNames: [String]
    
    //whether or not there are dividers betweeen
    var dividers : Bool = true

    var body: some View {
        
        HStack(spacing: -5) {
            
            ForEach(0...maxIndex, id: \.self) {
                index in
                
                //the title of the page
                Text(self.pageNames[index])
                    .pageControl_style(selected: index == self.index)
                    .onTapGesture {
                        self.index = index
                    }
                
                //Only want dividers between indices, not after the last
                if index != maxIndex && dividers{
                    Text("|")
                        .pageControl_style()
                }
            }
            
        }
        .pageControl_style()
    }
}

//MARK: Style

//text styling for page Control
extension Text {
    func pageControl_style(selected: Bool = false) -> some View {
        return self
            .bold()
            .foregroundColor(selected ?
                                .lightAccent :
                                Color.lightAccent.opacity(0.4))
            .padding(10)
    }
}

//view styling for page control
extension View {
    func pageControl_style() -> some View{
        return self
            .background(Color.darkAccent)
            .cornerRadius(25)
            .padding(.top,15)
            .padding(.horizontal, 30)
            .padding(.bottom,75)
            .shadow(color: Color.darkAccent.opacity(0.1), radius: 8)
    }
}
