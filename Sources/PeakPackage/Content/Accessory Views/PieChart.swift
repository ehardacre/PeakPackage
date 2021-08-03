//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 7/30/21.
//

import Foundation
import SwiftUI

struct PieSliceView: View {
    var pieSliceData: PieSliceData
    
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    
                    let center = CGPoint(x: width * 0.5, y: height * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                        clockwise: false)
                    
                }
                .fill(pieSliceData.color)
                
                Text(pieSliceData.text)
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                    )
                    .foregroundColor(Color.white)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceData {
    var startAngle: Angle
        var endAngle: Angle
        var text: String
        var color: Color
}

struct PrePieSliceData {
    var name: String
    var value: Double
    var color: Color
}

struct PrePieSliceList {
    var list : [PrePieSliceData]
    func compiledList(count: Int) -> [PrePieSliceData] {
        var temp : [PrePieSliceData] = []
        var otherTotal = 0.0
        for i in 0..<list.count {
            var element = list[i]
            if i >= count {
                //other
                otherTotal += element.value
            }else{
                //not other
                temp.append(list[i])
            }
        }
        if otherTotal > 0.0 {
            temp.append(PrePieSliceData(name: "Other", value: otherTotal, color: Color.darkAccent))
        }
        return temp
    }
    
    
    func getTotal() -> Double{
        return list.map({return $0.value}).reduce(0, { x, y in
            x + y
        })
    }
}

struct PieChartView: View {
    public var presliceData : PrePieSliceList
    public var itemCount : Int = 5
    
    public var backgroundColor: Color
    public var innerRadiusFraction: CGFloat = 0.6
    
    var slices: [PieSliceData] {
        let sum = presliceData.getTotal()
        let compiledList = presliceData.compiledList(count: itemCount)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, element) in compiledList.enumerated() {
            let degrees: Double = element.value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", element.value * 100 / sum), color: element.color))
            endDeg += degrees
        }
        return tempSlices
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.slices.count){ i in
                        PieSliceView(pieSliceData: self.slices[i])
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    
                    Circle()
                        .fill(Color.lightAccent)
                        .frame(width: geometry.size.width * innerRadiusFraction, height: geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text("Total")
                            .font(.title3)
                            .foregroundColor(Color.darkAccent)
                        Text(String(Int(presliceData.getTotal())))
                            .font(.title2)
                            .foregroundColor(Color.main)
                    }
                }
            }
            .background(Color.clear)
            .foregroundColor(Color.clear)
        }
    }

}
