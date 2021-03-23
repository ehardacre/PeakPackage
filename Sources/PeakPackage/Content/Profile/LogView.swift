//
//  LogView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/3/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI

struct LogView: View {
    
    var logs : [String]
    
    var body: some View {
        ZStack{
            List(){
                ForEach(
                    logs,
                    id: \.self){
                    log in
                    Text(log)
                        .font(.footnote)
                        .foregroundColor(.lightAccent)
                        .lineLimit(3)
                        .listRowInsets(.init(top: 0,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 0))
                    Divider()
                        .background(Color.lightAccent.opacity(0.5))
                        .listRowInsets(.init(top: 0,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 0))
                }
            }
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        #warning("TODO implement share logs")
                    }){
                        Image(
                            systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .foregroundColor(.main)
                            .padding()
                            .background(Color.darkAccent)
                            .cornerRadius(10)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Button(action: {
                        #warning("TODO implement copy logs")
                    }){
                        Image(systemName: "doc.on.doc")
                            .imageScale(.large)
                            .foregroundColor(.main)
                            .padding()
                            .background(Color.darkAccent)
                            .cornerRadius(10)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                Spacer()
            }
            .padding()
        }
        .background(Color.darkAccent)
        .cornerRadius(10)
    }
}
