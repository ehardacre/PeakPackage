//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 4/29/21.
//

import Foundation
import SwiftUI

class CalendarSelectionManager : ObservableObject{
    
    @Published var selection : Date? = nil
    
    func selectDate(_ date: Date?){
        selection = date
        NotificationCenter.default.post(Notification(name: Notification.Name("DateSelectionChange")))
    }
}

struct CalendarView2: View {
    
    @State var taskManager : TaskManager2
    @State var selectedMonth = 1
    @State var selectionMan = CalendarSelectionManager()
    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                TabView(selection: $selectedMonth) {
                    MonthView2(selectionMan: selectionMan, month: .last)
                        .tag(0)
                    MonthView2(selectionMan: selectionMan, month: .current)
                        .tag(1)
                    MonthView2(selectionMan: selectionMan, month: .next)
                        .tag(2)
                }
                .frame(width: geo.size.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            byDateTaskView(taskManager: taskManager, selectionMan: selectionMan)
            
        }
        .padding(0)
    }
}

struct byDateTaskView : View {
    
    @State var taskManager : TaskManager2
    @State var selectionMan : CalendarSelectionManager
    @State var text = "today"
    @State var makingNewTask = false
    
    var body : some View {
        VStack{
            HStack{
                HStack{
                    Text(text)
                        .CardTitle()
                }
                .padding(10)
                .background(Color.lightAccent)
                .cornerRadius(10)
                
                Spacer()
                
                
                Button(action: {
                    makingNewTask = true
                }, label: {
                    HStack{
                        Text("New Task")
                            .CardTitle()
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.darkAccent)
                            .imageScale(.large)
                    }
                })
                
                
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.black.opacity(0.1))
        .cornerRadius(20)
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "DateSelectionChange")), perform: { _ in
            if selectionMan.selection == nil {
                text = "today"
            }else{
                text = "\(selectionMan.selection!.abbreviatedMonth) \(selectionMan.selection!.get(.day))"
            }
        })
        .sheet(
            isPresented: $makingNewTask,
            content: {
                NewTaskPage(forms: taskManager.forms)
        })
    }
}

