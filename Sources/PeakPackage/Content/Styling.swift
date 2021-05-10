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
    func CleanList(rowH : CGFloat = 120) -> some View{
        return self
            .listRowBackground(Color.clear)
            .listStyle(SidebarListStyle())
            .environment(\.defaultMinListRowHeight, rowH)
    }
    
    func FormList() -> some View{
        return self
            .listRowBackground(Color.clear)
            .listStyle(SidebarListStyle())
            .environment(\.defaultMinListRowHeight, 60)
    }
}

extension Text {
    func SectionTitle() -> some View{
        return self
            .bold()
            .font(.title2)
            .foregroundColor(Color.darkAccent)
    }
    
    func CardTitle() -> some View{
        return self
            .font(.headline)
            .foregroundColor(.darkAccent)
    }
    
    func Caption() -> some View{
        return self
            .font(.caption)
            .foregroundColor(.darkAccent)
            .opacity(0.5)
            .truncationMode(.tail)
            .lineLimit(1)
    }
    
    func CardTitle_light() -> some View{
        return self
            .font(.headline)
            .foregroundColor(.lightAccent)
    }
    
    func Caption_light() -> some View{
        return self
            .font(.caption)
            .foregroundColor(.lightAccent)
            .opacity(0.8)
            .truncationMode(.tail)
            .lineLimit(1)
    }
    
    func ButtonText() -> some View {
        return self
            .bold()
            .foregroundColor(.darkAccent)
    }
    
    func ColorButtonText() -> some View {
        return self
            .bold()
            .foregroundColor(.main)
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
            .buttonStyle(PlainButtonStyle())
            .fullWidth()
    }
    
    func RoundRectButton_NotCentered() -> some View {
        return self
            .padding(pads)
            .overlay(
                RoundedRectangle(cornerRadius: corners)
                    .stroke(Color.darkAccent, lineWidth: borderRadius)
            )
            .buttonStyle(PlainButtonStyle())
    }
    
    func defaultDateSelectButton() -> some View {
        return self
            .padding(7)
            .background(Color.gray.opacity(0.15))
            .foregroundColor(.blue)
            .cornerRadius(4)
    }
    
    func TrailingButton() -> some View {
        return self
            .buttonStyle(PlainButtonStyle())
            .padding(pads)
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
    
    func BasicContentCard() -> some View {
        return self
            .padding(pads)
            .background(Color.lightAccent)
            .cornerRadius(corners)
    }
    
}
