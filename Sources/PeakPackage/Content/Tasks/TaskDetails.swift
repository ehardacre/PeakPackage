//
//  TaskDetails.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/14/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

struct TaskDetails: View {
    
    var task : Task
    @State var pickerSelection = 0
    @State var initialPosition = 0
    let pickerOptions = ["Requested","In Progress","Complete"]
    
    @ObservedObject var stopWatchManager = StopWatchManager()
    
    @State var timeText = ""
    
    var body : some View {
        VStack{
            Image("peak").resizable().frame(width: 50, height: 50)
            Text(task.type == "user_requested" ? "Requested" : "Complimentary")
            Text(TaskManager.cleanDate(task.date))
            Divider().frame(width: 200)
            Text(task.request)
            Spacer()
            if defaults.admin {
            if pickerSelection == 1 {
                Group{
                    HStack{
                        Spacer()
                        Button(action: {
                            if self.stopWatchManager.mode == .running {
                                self.stopWatchManager.pause()
                            }else{
                                self.stopWatchManager.start()
                            }
                        }){
                            Image(systemName: self.stopWatchManager.mode == .running ? "pause.fill" : "play.fill").resizable().frame(width: 20, height: 20).foregroundColor(.lightAccent)
                        }
                        
                        HStack{
                            Spacer()
                            if self.stopWatchManager.hoursElapsed > 0 {
                                Text("\(self.stopWatchManager.hoursElapsed) \(self.stopWatchManager.hoursElapsed == 1 ? "hour" : "hours") ").bold().foregroundColor(Color.lightAccent)
                            }
                            
                            Text("\(self.stopWatchManager.minutesElapsed) \(self.stopWatchManager.minutesElapsed == 1 ? "minute" : "minutes") ").bold().foregroundColor(Color.lightAccent)
                            
                            Spacer()
                        
                        }
                        
                        Spacer()
                        

                    }.padding(20).background(Color.darkAccent).clipShape(Capsule())
                }
            } else if pickerSelection == 0 {
                Group{
                                   HStack{
                                       Spacer()
                                    if self.stopWatchManager.mode == .running{
                                        VStack{
                                            Text("Task is in Progress").bold().foregroundColor(.lightAccent)
                                            Text("Tap again to remove yourself from task").opacity(0.5).foregroundColor(.lightAccent).font(.footnote)
                                        }
                                    }else{
                                        if self.stopWatchManager.minutesElapsed > 0 || self.stopWatchManager.hoursElapsed > 0 {
                                            Text("Resume Task").bold().foregroundColor(.lightAccent)
                                        }else{
                                            Text("Start Task").bold().foregroundColor(.lightAccent)
                                        }
                                    }
                                       Spacer()
                                   }.padding(20).background(Color.darkAccent).clipShape(Capsule()).onTapGesture {
                                    if self.stopWatchManager.mode == .running{
                                        self.stopWatchManager.stop()
                                    }else{
                                        self.pickerSelection = 1
                                        self.stopWatchManager.start()
                                    }
                    }
                }
            } else if pickerSelection == 2 {
                Group{
                                   HStack{
                                       Spacer()
                                    VStack{
                                        Text("Mark as Complete").bold().foregroundColor(.lightAccent)
                                        Text("This will notify the client").opacity(0.5).foregroundColor(.lightAccent).font(.footnote)
                                    }
                                       Spacer()
                                   }.padding(20).background(Color.darkAccent).clipShape(Capsule()).onTapGesture {
                                    //
                                   }.onAppear{
                                    self.stopWatchManager.pause()
                    }
                }
            }
            Picker(selection: $pickerSelection, label: Text(""), content: {
                //display each of the duration choices
                ForEach(0 ..< pickerOptions.count){ i in
                    Text(self.pickerOptions[i])
                }
            }).pickerStyle(SegmentedPickerStyle()).frame(height: 30)
                .padding(.horizontal, 30)
            }
        }.padding(30).onAppear{
            if task.getType().status == TaskStatus.complete{
                pickerSelection = 2
                initialPosition = 2
            }else if task.getType().status == TaskStatus.inProgress{
                pickerSelection = 1
                initialPosition = 1
            }
        }
    }
}

enum stopWatchMode {
    case running
    case stopped
    case paused
}

class StopWatchManager : ObservableObject {
    
    //TODO: timer is off and isn't working in bg. potential solution could be saving a start time in defaults and then on the interval check the difference between current time and start time. One problem is how to handle pauses
    
    @Published var minutesElapsed = 0
    @Published var hoursElapsed = 0
    @Published var mode: stopWatchMode = .stopped
   
    var timer = Timer()
    
    func start() {
       
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            if self.mode == .running {
                self.minutesElapsed += 1
                if self.minutesElapsed == 60 {
                    self.hoursElapsed += 1
                    self.minutesElapsed = 0
                }
            }
        }
    }
    
    func pause() {
        mode = .paused
    }
    
    func stop() {
        timer.invalidate()
        minutesElapsed = 0
        hoursElapsed = 0
        mode = .stopped
    }
}
