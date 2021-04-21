//
//  Header.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 9/8/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI

struct Header: View {
    
    @ObservedObject var viewRouter: ViewRouter
    //is back button shown
    @State var back = true
    
    var body: some View {
        ZStack{
            HStack{
                Image(uiImage: defaults.banner)
                    .resizable()
                    .frame(width: 200,height: 100)
                    .padding(.top, 40)
                    .background(Color.clear)
            }
            HStack{
                if back{
                    Button(action: {
                        self.viewRouter.back()
                    }){
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .padding([.top,.leading])
                            .foregroundColor(Color.darkAccent)
                    }
                }
                Spacer()
            }
        }
    }
}

