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
    @Published var unavailableDates : [Int] = []
    
    func addSelection(_ selection: Int?, from times: [Date]) -> (start: Date, end: Date)?{
        if selection != nil {
            var addedUp = false
            if datesSelected.contains(selection!){
                datesSelected = [selection!]
            }else if unavailableDates.contains(selection!) {
                //do nothing
            }else if datesSelected.contains(selection! - 1){
                addedUp = false
                datesSelected.append(selection!)
            }else if datesSelected.contains(selection! + 1){
                addedUp = true
                datesSelected.append(selection!)
            }else{
                datesSelected = [selection!]
            }
            datesSelected.sort()
            if datesSelected.count > 4 {
                if addedUp{
                    _ = datesSelected.removeLast()
                }else{
                    _ = datesSelected.removeFirst()
                }
            }
        }
        
        if datesSelected.count > 0 {
            let startIndex = datesSelected.first!
            let endIndex = datesSelected.last!
            let start = times[startIndex]
            let end = Calendar.current.date(byAdding: .minute, value: TaskManager2.timeSlotInterval/2, to: times[endIndex])!
            return (start: start, end: end)
        }
        
        return nil
        
    }
    
    func addUnavailableTimes(timeSlots: [appointmentTimeSlot], startTime: Date, endTime: Date){
        let formatterOne = DateFormatter()
        formatterOne.dateFormat = "HH:mm:ss"
        formatterOne.timeZone = TimeZone(abbreviation: "GMT")
        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "yyyy-MM-dd"
        formatterTwo.timeZone = TimeZone(abbreviation: "GMT")
        let formatterThree = DateFormatter()
        formatterThree.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatterThree.timeZone = TimeZone(abbreviation: "GMT")
        for time in timeSlots {
            if let date = time.getDate(), let start = time.getStartTime(), let end = time.getEndTime(){
                let baseDate = formatterTwo.string(from: date)
                let newStartTime = formatterOne.string(from: start)
                let newStartString = "\(baseDate) \(newStartTime)"
                var newStart = formatterThree.date(from: newStartString)!
                newStart = newStart.toGlobalTime()
                let newEndTime = formatterOne.string(from: end)
                let newEndString = "\(baseDate) \(newEndTime)"
                var newEnd = formatterThree.date(from: newEndString)!
                newEnd = newEnd.toGlobalTime()
                let disStart = startTime.distance(to: newStart)/60
                let disEnd = startTime.distance(to: newEnd)/60
                let indStart = (Int(disStart)/(TaskManager2.timeSlotInterval/2)) + 4
                let indEnd = (Int(disEnd)/(TaskManager2.timeSlotInterval/2)) + 4
                for i in indStart..<indEnd{
                    unavailableDates.append(i)
                }
            }
        }
    }
    
}

struct AppointmentSelectionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var selector = appointmentSelector()
    @State var taskManager : TaskManager2
    
    var startTime : Date
    var endTime : Date
    var timeIntervalList : [Date] = []
    let timeformatter = DateFormatter()
    @State var confirmationText = ""
    @State var isTimeSelected = false
    @Binding var inputStartTime : Date?
    @Binding var inputEndTime : Date?
    @Binding var timeText : String
    
    let rowH : CGFloat = 100
    
    init(taskManager: TaskManager2, inputStartTime: Binding<Date?>, inputEndTime: Binding<Date?>, text: Binding<String>, selectedDate: Date){
        self._taskManager = .init(initialValue: taskManager)
        startTime = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: selectedDate)!.toLocalTime() //9AM EST
        endTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: selectedDate)!.toLocalTime() //5PM EST
        var time = startTime
        self._inputStartTime = inputStartTime
        self._inputEndTime = inputEndTime
        self._timeText = text
        if time.distance(to: endTime) < 0{
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        }
        while time.distance(to: endTime) > 0{
            timeIntervalList.append(time)
            time = Calendar.current.date(byAdding: .minute, value: TaskManager2.timeSlotInterval/2, to: time) ?? time
        }
        timeformatter.dateFormat = "hh:mm"
        selector.addUnavailableTimes(timeSlots: taskManager.unavailabaleTimeSlots, startTime: startTime, endTime: endTime)
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
                        }
                    }
                }
            }
            .padding(20)
            
            VStack{
                Spacer()
                Button(action: {
                    if selector.datesSelected.count > 0 {
                        let range = selector.addSelection(nil, from: timeIntervalList)
                        inputStartTime = range?.start
                        inputEndTime = range?.end
                        timeText = confirmationText
                        presentationMode.wrappedValue.dismiss()
                    }
                },label:{
                    Text("Confirm \(confirmationText)")
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
