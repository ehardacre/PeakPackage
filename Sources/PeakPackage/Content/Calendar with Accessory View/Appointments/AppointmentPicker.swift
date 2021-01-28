//
//  AppointmentPicker.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/2/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

struct AppPicker: View {
    
    //the call calendar that called this picker
    var parent: CallCalendarView
    @Binding var showing : Bool
    
    //default values
    @State var tomorrow = Date(timeIntervalSinceNow: Date.day)
    @State var datePicked = Date(timeIntervalSinceNow: Date.day)
    @State var appReason = ""
    
    //items for revolving picker
    //TODO: why are there two of these??
    @State var durItms: [String] = ["10 min", "20 min", "30 min", "45 min", "1 hr"]
    let durItmsMin: [String] = ["10 minutes.","20 minutes.","30 minutes.","45 minutes.","60 minutes"]
    
    //selce
    @State var selectedTime = 2
    
    @State var showError = false

    
    var body: some View{
    
        
        VStack{

            //group needed because too many UI elements for stack
            Group{
                ZStack{
                    Image(systemName: "calendar.badge.plus").imageScale(.large)
                    HStack{
                        Button(action: {
                            showing = false
                        }){
                            Text("Cancel").foregroundColor(.darkAccent)
                        }
                        Spacer()
                    }
                }
            }.padding(.bottom, 50)
        
            //Inputs
            Group{
                
                VStack{
                    
                    DatePicker(selection: $datePicked, in: tomorrow...) {
                        Text("Date/Time").foregroundColor(.darkAccent).opacity(0.5)
                    }
                    
                    Picker(selection: $selectedTime, label: Text("Duration:"), content: {
                        //display each of the duration choices
                        ForEach(0 ..< durItms.count){ i in
                            Text(self.durItms[i])
                        }
                    }).pickerStyle(SegmentedPickerStyle()).frame(height: 30)
                
                }
                
                VStack{
                    TextField("Appointment Reason", text: $appReason).padding(.horizontal, 30).frame(height: 50)
                    if showError{
                        Text("You must provide a reason for the call.").font(.footnote).foregroundColor(Color.red)
                    }
                }
                .padding(.vertical,15)
                .background(Color.lightAccent)
                .cornerRadius(10)
                .shadow(color: Color.darkAccent.opacity(0.2), radius: 5)
                
            }


            //show error if user picks a weekend
            if Calendar.current.component(.weekday, from: datePicked) == Date.saturday || Calendar.current.component(.weekday, from: datePicked) == Date.sunday{
                Text("Sorry we're closed on the weekends").foregroundColor(Color.red).onAppear{
                    self.changeDate()
                }
            }

            Button(action: {
                self.makeAppointment()
            }, label: {
                Text("Schedule")
                .foregroundColor(Color.darkAccent)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.darkAccent)
                )
            })
            .padding(.top,30)

            Spacer()
        }.padding(30)
            
    }
    
    func makeAppointment(){
        if self.appReason != "" {
            self.parent.makeAppointment(date: self.datePicked, duration: self.durItmsMin[self.selectedTime], reason: self.appReason)
        }
    }
    
    //changes a weekend date to the nearest weekday
    func changeDate() {
        
        //sunday
        if Calendar.current.component(.weekday, from: datePicked) == Date.sunday{
            datePicked = Date(timeInterval: Date.day, since: datePicked)
        //saturday
        }else if Calendar.current.component(.weekday, from: datePicked) == Date.saturday{
            datePicked = Date(timeInterval: Date.day*2, since: datePicked)
        }
        
    }
    
}
