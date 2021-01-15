//
//  WizardView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/3/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI

struct WizardView: View {
    
    @State var pointer : CGPoint
    let triangleSize : CGFloat = 100
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 20)
            Triangle()
                .path(in: CGRect(x: pointer.x - triangleSize/2, y: pointer.y - triangleSize, width: triangleSize, height: triangleSize))
                .background(Color.red)
        }
    }
}

extension View {
    
    func wizard(showing: Binding<Bool>, frame: Binding<CGRect>) -> some View{
        return
            ZStack{
                //TODO
                self
            }
    }
    
    func rectReader(_ binding: Binding<CGRect>) -> some View{
        return GeometryReader{ (geo) -> AnyView in
            let rect = geo.frame(in: .global)
            DispatchQueue.main.async {
                binding.wrappedValue = rect
            }
            return self as! AnyView
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}
