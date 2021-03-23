//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/19/21.
//

import Foundation
import SwiftUI

fileprivate let corners: CGFloat = 20.0
fileprivate let pads: CGFloat = 15.0
fileprivate let borderRadius : CGFloat = 2.0

extension List {
    func CleanList() -> some View{
        return self
            .listRowBackground(Color.clear)
            .listStyle(SidebarListStyle())
    }
}

extension Text {
    func SectionTitle() -> some View{
        return self
            .bold()
            .font(.title2)
            .foregroundColor(Color.darkAccent)
    }
    
    func Caption() -> some View{
        return self
            .font(.footnote)
            .foregroundColor(.darkAccent)
            .opacity(0.5)
    }
    
    func ButtonText() -> some View {
        return self
            .bold()
            .foregroundColor(.darkAccent)
    }
}

extension Button {
    func RoundRectButton() -> some View {
        return self
            .padding(pads)
            .overlay(
                RoundedRectangle(cornerRadius: corners)
                    .stroke(Color.darkAccent, lineWidth: borderRadius)
            )
            .fullWidth()
    }
}

extension View {
    
    func fullWidth() -> some View{
        HStack{
            Spacer()
            self
            Spacer()
        }
    }
    
}
