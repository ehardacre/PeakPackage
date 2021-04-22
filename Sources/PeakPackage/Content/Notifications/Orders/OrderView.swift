//
//  OrderView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 12/11/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

struct OrderCardView: View {
    
    @ObservedObject var selectionManager : SelectionManager
    @ObservedObject var notificationMan : NotificationManager
    @State var showMoreInfo = false
    
    //needs an id as an identifier for list
    var id = UUID()
    var order : Order
    //height of the row
    var height : CGFloat = 105
    
    var body: some View {
        //UI elements
        GeometryReader{
            geo in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.lightAccent)
                .frame(height: self.height)
                .overlay(
                    HStack{
                        ZStack{
                            //determines the image that is placed on the left side of the card
                            if order.notification_state == orderType.pending.rawValue {
                                Rectangle()
                                    .fill(Color.darkAccent)
                                    .frame(width: 50.0)
                                Image(systemName: "clock")
                                    .imageScale(.large)
                                    .foregroundColor(.mid)
                            } else { //processing
                                Rectangle()
                                    .fill(Color.lightAccent)
                                    .frame(width: 50.0)
                                Image(
                                    systemName: "cube.box")
                                    .imageScale(.large)
                                    .foregroundColor(.mid)
                            }
                        }
                        VStack(alignment: .leading) {
                            
                            Text(order.notification_key)
                                    .font(.headline)
                                    .foregroundColor(.darkAccent)
                            HStack{
                                Text(formatDate(order.notification_date))
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(formatTime(order.notification_date))
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: self.height)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                (self.id == self.selectionManager.id) ?
                                    Color.blue : Color.mid,
                                lineWidth:
                                    (self.id == self.selectionManager.id) ?
                                    3 : 1))
                    )
                    .onTapGesture(
                        count: 1,
                        perform: {
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
                #warning("TODO implement an order info sheet")
            })
        }
    }

///processes information for display
extension OrderCardView {
    
    func formatDate(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        date = date.toLocalTime()
        let dateString = date.dayOfWeekWithMonthAndDay
        return dateString
    }
    
    func formatTime(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        date = date.toLocalTime()
        let dateString = date.timeOnlyWithPadding
        return dateString
    }
}
