//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 5/9/21.
//

import Foundation
import SwiftUI

class appointmentSelector : ObservableObject {
    
    @Published var datesSelected : [Int] = []
    @Published var unavailableDates : [Int] = [8,9,10]
    let interval = 30
    
    func addSelection(_ selection: Int, from times: [Date]) -> (start: Date, end: Date)?{
        var addedUp = false
        if datesSelected.contains(selection){
            datesSelected = [selection]
        }else if unavailableDates.contains(selection) {
            //do nothing
        }else if datesSelected.contains(selection - 1){
            addedUp = false
            datesSelected.append(selection)
        }else if datesSelected.contains(selection + 1){
            addedUp = true
            datesSelected.append(selection)
        }else{
            datesSelected = [selection]
        }
        datesSelected.sort()
        if datesSelected.count > 4 {
            if addedUp{
                _ = datesSelected.removeLast()
            }else{
                _ = datesSelected.removeFirst()
            }
        }
        
        if datesSelected.count > 0 {
            let startIndex = datesSelected.first!
            let endIndex = datesSelected.last!
            let start = times[startIndex]
            let end = Calendar.current.date(byAdding: .minute, value: interval/2, to: times[endIndex])!
            return (start: start, end: end)
        }
        
        return nil
        
    }
    
}

struct AppointmentSelectionView: View {
    
    @ObservedObject var selector = appointmentSelector()
    var startTime = Calendar.current.date(bySetting: .hour, value: 11, of: Date())!
    var endTime =
        Calendar.current.date(bySetting: .hour, value: 19, of: Date())!
    var test = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
    var timeIntervalList : [Date] = []
    let timeformatter = DateFormatter()
    @State var confirmationText = "no time selected"
    @State var isTimeSelected = false
    @State var selectedTimes : [Date] = []
    
    let rowH : CGFloat = 100
    
    init(){
        var time = startTime
        print(startTime)
        print(endTime)
        if time.distance(to: endTime) < 0{
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        }
        while time.distance(to: endTime) > 0{
            timeIntervalList.append(time)
            time = Calendar.current.date(byAdding: .minute, value: selector.interval/2, to: time) ?? time
        }
        timeformatter.dateFormat = "hh:mm"
    }
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 0){
                    ForEach(0..<timeIntervalList.count, id: \.self){ index in
                        if index%2 == 0 {
                            //first 15
                            VStack{
                                ZStack{
                                    //label
                                    VStack(spacing: 0){
                                        Divider()
                                        HStack{
                                            Text(timeformatter.string(from: timeIntervalList[index]))
                                                .CardTitle()
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .frame(height: rowH/2)
                                    
                                    //selection
                                    HStack{
                                        if selector.datesSelected.contains(index){
                                            Color.main.opacity(0.5)
                                        }else if selector.unavailableDates.contains(index){
                                            Color.darkAccent.opacity(0.2)
                                        }else{
                                            Color.lightAccent.opacity(0.5)
                                        }
                                    }
                                    .frame(height: rowH/2)
                                    .padding(.leading, 60)
                                }
                            }
                            .frame(height: rowH/2)
                            .onTapGesture {
                                let range = selector.addSelection(index,from: timeIntervalList)
                                isTimeSelected = true
                                if range != nil{
                                    let startStr = timeformatter.string(from: range!.start)
                                    let endStr = timeformatter.string(from: range!.end)
                                    confirmationText = "\(startStr)-\(endStr)"
                                }
                            }
                        }else{
                            //second 15
                            VStack{
                                ZStack{
                                    //label
                                    VStack(spacing: 0){
                                        Divider()
                                        Spacer()
                                    }
                                    .padding(.horizontal,50)
                                    .frame(height: rowH/2)
                                    
                                    //selection
                                    HStack{
                                        if selector.datesSelected.contains(index){
                                            Color.main.opacity(0.5)
                                        }else if selector.unavailableDates.contains(index){
                                            Color.darkAccent.opacity(0.2)
                                        }else{
                                            Color.lightAccent.opacity(0.5)
                                        }
                                    }
                                    .frame(height: rowH/2)
                                    .padding(.leading, 50)
                                }
                            }
                            .frame(height: rowH/2)
                            .onTapGesture {
                                let range = selector.addSelection(index,from: timeIntervalList)
                                isTimeSelected = true
                                if range != nil{
                                    let startStr = timeformatter.string(from: range!.start)
                                    let endStr = timeformatter.string(from: range!.end)
                                    confirmationText = "\(startStr)-\(endStr)"
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            
            VStack{
                Spacer()
                Button(action: {
                    
                },label:{
                    Text(confirmationText)
                        .CardTitle_light()
                })
                .padding(20)
                .background(isTimeSelected ? Color.main : Color.darkAccent.opacity(0.2))
                .cornerRadius(20)
            }
            .padding(20)
        }
    }
    
    func appointmentAvailable() -> Bool {
        return true
    }
}
