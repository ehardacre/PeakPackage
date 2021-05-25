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
        NotificationCenter.default.post(Notification(name: Notification.Name("DateSelectionChange"),object: date))
    }
}

struct CalendarView2: View {
    
    @State var taskManager : TaskManager2
    @State var selectedMonth = 1
    @State var selectionMan = CalendarSelectionManager()
    @State var calendarShowing = false
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 0){
                
                TaskCalendarHeader(taskManager: taskManager, selectionMan: selectionMan, calendarShowing: $calendarShowing)
                
                Divider()
                    .foregroundColor(Color.darkAccent)
                    .frame(width: geo.size.width, height: 2)
                    .padding(0)
                
                TabView(selection: $selectedMonth) {
                    MonthView2(selectionMan: selectionMan, month: .last)
                        .tag(0)
                    MonthView2(selectionMan: selectionMan, month: .current)
                        .tag(1)
                    MonthView2(selectionMan: selectionMan, month: .next)
                        .tag(2)
                }
                .padding(0)
                .frame(width: geo.size.width, height: calendarShowing ? geo.size.height/2 : 0)
                .opacity(calendarShowing ? 1 : 0)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onAppear{
                    selectedMonth = 2
                }
                
                byDateTaskView(taskManager: taskManager)
                    .padding(0)
                
            }
            .padding(0)
        }
    }
}

struct byDateTaskView : View {
    
    @State var taskManager : TaskManager2
    
    var body : some View {
        VStack{
            
            TaskListView2(taskManager: taskManager)
                .cornerRadius(20)
            
            Spacer()
        }
        .background(Color.lightAccent)
        .cornerRadius(20)
    }
}

struct TaskCalendarHeader : View {
    
    @State var taskManager : TaskManager2
    @State var selectionMan : CalendarSelectionManager
    @Binding var calendarShowing : Bool
    @State var text = "today"
    @State var makingNewTask = false
    
    var body : some View {
        HStack{
            HStack{
                Text(text)
                    .CardTitle()
            }
            .padding(10)
            .background(Color.lightAccent)
            .cornerRadius(10)
            .onTapGesture {
                selectionMan.selectDate(nil)
            }
            Image(systemName: "calendar")
                .imageScale(.large)
                .foregroundColor(.darkAccent)
                .padding(10)
                .background(calendarShowing ? Color.lightAccent : Color.clear)
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation{
                        calendarShowing.toggle()
                    }
                }
            
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
        .padding(20)
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
                NewTaskPage(taskManager: taskManager, forms: taskManager.forms)
        })
    }
}

