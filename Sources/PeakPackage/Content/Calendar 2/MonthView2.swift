//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 4/29/21.
//

import Foundation
import SwiftUI

struct MonthView2: View{
    
    @State var selectionMan : CalendarSelectionManager
    @State var month : DisplayMonth
    enum DisplayMonth : Int{
        case last = -1
        case current = 0
        case next = 1
        
        func getName() -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let date = Calendar.current.date(byAdding: .month, value: self.rawValue, to: Date())
            return dateFormatter.string(from: date!)
        }
        
        func getDays(_ selectionMan: CalendarSelectionManager) -> [DayView2]{
            let referenceDate = Calendar.current.date(byAdding: .month, value: self.rawValue, to: Date())!
            let components = Calendar.current.dateComponents([.year, .month], from: referenceDate)
            let startofMonth = Calendar.current.date(from: components)!
            let dayOfWeek = Calendar.current.component(.weekday, from: startofMonth)
            
            var dateList : [DayView2] = []
            for _ in 1..<dayOfWeek {
                dateList.append(DayView2(day: nil, selectionMan: selectionMan))
            }
            var lookingDate = startofMonth
            while lookingDate.get(.month) == startofMonth.get(.month) {
                var isToday = false
                if lookingDate.get(.day) == Date().get(.day) &&
                    lookingDate.get(.month) == Date().get(.month){
                    isToday = true
                }
                dateList.append(DayView2(day: lookingDate, today: isToday, selectionMan: selectionMan))
                lookingDate = Calendar.current.date(byAdding: .day, value: 1, to: lookingDate)!
            }

            return dateList
        }
    }
    
    var columns: [GridItem] = [
            GridItem(), //S
            GridItem(), //M
            GridItem(), //T
            GridItem(), //W
            GridItem(), //Th
            GridItem(), //F
            GridItem()  //S
        ]
    
    var columnHeaders: [String] = ["Su","M","T","W","Th","F","S"]
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                Text(month.getName())
                    .CardTitle()
                LazyVGrid(columns: columns){
                    ForEach(columnHeaders, id: \.self) { header in
                        Text(header)
                            .font(.footnote)
                    }
                    ForEach(month.getDays(selectionMan), id: \.id) { dateView in
                        dateView
                    }
                    ForEach(0..<7, id: \.self) { _ in
                        Text("") ///blank rows for spacing fix
                    }
                }
            }
            .padding(20)
            .frame(width: geo.size.width)
            .background(Color.darkAccent.opacity(0.1))
            .cornerRadius(20)
        }
        .padding(20)
    }

}
