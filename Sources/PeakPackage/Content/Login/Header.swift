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
        
        //header
        HStack{
           //TODO: add image  component
            //TODO: fix the elements in the container
            if back{
                Button(action: {
                    self.viewRouter.back()
                }){
                    Image(systemName: "chevron.left").resizable().frame(width: 20, height: 20).padding([.top,.leading])
                }
            }else{
                Button(action: {
                    //no need for action, this is for spacing
                }){
                    Image(systemName: "chevron.left").resizable().frame(width: 20, height: 20).padding([.top,.leading])
                }.hidden()
            }
            Spacer()
            //logo
            Image(uiImage: defaults.banner).resizable().frame(width: 200,height: 100)
                .padding(.top, 40).padding(.trailing,40).background(Color.clear)
            Spacer()
        }
    }
}

