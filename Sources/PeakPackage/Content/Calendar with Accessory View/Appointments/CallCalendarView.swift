//
//  CallCalendarView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 7/28/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI
import Introspect

//MARK: Call Calendar View
/**
 # Call Calendar View
 The view for the Calendar
 utilizes  [https://github.com/ThasianX/ElegantCalendar#installation](Elegant Calendar)
 */
struct CallCalendarView: View {
    
    //calendar specs and objects
    @ObservedObject private var calendarManager: MonthlyCalendarManager
    @State private var calendarTheme: CalendarTheme = CalendarTheme(primary: .darkAccent)

    //dictionarly for appointments by day
    let visitsByDay: [Date: [Visit]]
    
    //shows the date picker view
    @State var showPick = false
    
    //the content view that holds the calendar view
    //var parent : ContentView
    
    // Call Calendar View
    init(ascVisits: [Visit]) {
        
       // parent = content
        
        //initialize the calendar configs
        let configuration = CalendarConfiguration(
            calendar: currentCalendar,
            startDate: Date(),
            endDate: Date.daysFromToday(30))
        calendarManager = MonthlyCalendarManager(
            configuration: configuration,
            initialMonth: .daysFromToday(0))

        //initilize the visits by day
        visitsByDay = Dictionary(
            grouping: ascVisits,
            by: { currentCalendar.startOfDay(for: $0.arrivalDate) })
        
        calendarManager.selectedDate = Date()
        calendarManager.datasource = self
        calendarManager.delegate = self
    }
    
    //UI Elements
    var body: some View {

        ZStack{
            if UIDevice.current.userInterfaceIdiom != .pad {
                
                MonthlyCalendarView(calendarManager: self.calendarManager)
                    .theme(self.calendarTheme).padding(.top, -50)
                
                VStack{
                    
                        HStack{
                            
                            Spacer()
                            
                            //a button to add a calendar event
//                            Button(action: {
//                                self.showPick = true
//                            }, label: {
//                                Image("add").resizable().frame(width: 30, height: 30).foregroundColor(Color.darkAccent)
//                            }).padding(.top,20).padding(.trailing,70)
                            
                        //HStack end
                        }
                    
                    Spacer()
                        
                    }
                    
                    
                //VStack end
            }else{
                GeometryReader{ geo in
                    HStack{
                            VStack{
                                MonthlyCalendarView(calendarManager: self.calendarManager)
                                    .theme(self.calendarTheme).background(Color.white).padding(.top,20)
                                }.frame(width: 400)
                            VStack{
                                AppPicker(parent: self, showing: $showPick)
                            }
                    }
                }
            }
            VStack{
                Spacer()
                if calendarManager.selectedDate != nil && Date().distance(to: calendarManager.selectedDate ?? Date()) >= TimeInterval(86400) {
                    HStack{
                        
                        Button(action: {
                            
                                self.showPick = true
                            
                        }){
                            Text("+ New Appointment").bold().foregroundColor(Color.lightAccent)
                        }.cornerRadius(10).padding(10).background(Color.darkAccent)
                    }.pageControl_style()
                }

            }
        //ZStack end
        }.popover(isPresented: $showPick, content: {
            
            //appointment picker view
            AppPicker(parent: self, showing: $showPick)
                .introspectViewController{
                    $0.isModalInPresentation = showPick
                }
            
        })
    }
    
    /**
     # Make Appointment
      submits an appointment to the database
     */
    func makeAppointment(date: Date, duration: String, reason: String){
//
//        //picker view has already been shown
//        self.showPick = false
//
//        //format the date for the database
//        let formattedDate = date.databaseFormat()
//
//        //get the user id
//        let id = defaults.franchiseId()!
//
//        //TODO: database requests done differently now
//        
//        //create the json object for a new appointment
//        let json = JsonFormat.setAppointment(id: id, value: reason, date: formattedDate, duration: duration).format()
//
//        //perform the request
//        DatabaseDelegate.performRequest(with: json, ret: returnType.string, completion: {
//            rex in
//            //self.parent.appointmentManager.resetAppointments()
//        })
    }
    
}

//MARK: Calendar Data Source
extension CallCalendarView: MonthlyCalendarDataSource {

    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return Double((visitsByDay[startOfDay]?.count ?? 0) + 1) / 10.0
    }

    func calendar(canSelectDate date: Date) -> Bool {
       // let day = currentCalendar.dateComponents([.day], from: date).day!
        let day = currentCalendar.dateComponents([.weekday], from: date).weekday!
        return (day != 1 && day != 7)
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return VisitsListView(visits: visitsByDay[startOfDay] ?? [], height: size.height).erased
    }

}

//MARK: Calendar Delegate
extension CallCalendarView: MonthlyCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}

