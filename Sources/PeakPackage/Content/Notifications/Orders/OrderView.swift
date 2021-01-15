//
//  OrderView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 12/11/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

class SelectionManager: ObservableObject {
    @Published var id : UUID?
}

struct OrderCardView: View {
    
    //needs an id as an identifier for list
    var id = UUID()
    @ObservedObject var selectionManager : SelectionManager
    @ObservedObject var notificationMan : NotificationManager
    
    var order : Order
    
    //height of the row
    var height : CGFloat = 105
    
    @State var showMoreInfo = false
    
    var body: some View {
        
        //UI elements
        GeometryReader{ geo in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.lightAccent)
                .frame(height: self.height)
                .overlay(
                    HStack{
                        ZStack{
                            //determines the image that is placed on the left side of the card
                            if order.notification_state == orderType.pending.rawValue {
                                Rectangle().fill(Color.darkAccent).frame(width: 50.0)
                                Image(systemName: "clock").imageScale(.large).foregroundColor(.mid)
                            } else { //processing
                                Rectangle().fill(Color.lightAccent).frame(width: 50.0)
                                Image(systemName: "cube.box").imageScale(.large).foregroundColor(.mid)
                            }
                            
                        //ZSTACK end
                        }
                        
                        //displaying the content on the card
                            VStack(alignment: .leading) {
                                
                                Text(order.notification_key)
                                        .font(.headline)
                                        .foregroundColor(.darkAccent)
//                                Text(order.notification_value)
//                                        .font(.caption)
//                                        .foregroundColor(.secondary)
//                                        .truncationMode(.tail)
//                                        .lineLimit(1)
                                HStack{
                                    Text(formatDate(order.notification_date))
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(formatTime(order.notification_date))
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                
                            //VSTACK end
                            }
                        
                        Spacer()
                        
                        
                        
                    //HSTACK
                    }.frame(width: geo.size.width, height: self.height)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke((self.id == self.selectionManager.id) ? Color.blue : Color.neutral, lineWidth: (self.id == self.selectionManager.id) ? 3 : 1))
                        //OVERLAY end
                        )
                .onTapGesture(count: 2, perform: {
                    if self.id == self.selectionManager.id {
                        self.selectionManager.id = nil
                    }else{
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        self.selectionManager.id = self.id
                        self.showMoreInfo = true
                    }
                    
                })
    
                
            }
            .sheet(isPresented: self.$showMoreInfo, content: {
               // OrderInfoSheet(order: order, notificationMan: notificationMan)
            })
        }
    
    }

extension OrderCardView {
    func formatDate(_ str_date: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        
        date = date.toLocalTime()
        
        var dateString = date.dayOfWeekWithMonthAndDay
        
    
        return dateString
    }
    
    func formatTime(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        
        date = date.toLocalTime()
        
        var dateString = date.timeOnlyWithPadding
        
    
        return dateString
    }
}
