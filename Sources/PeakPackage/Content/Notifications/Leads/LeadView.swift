//
//  LeadView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/5/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

//MARK: Task Card View

struct LeadCardView: View {
    
    private let calendarIcon = "calendar"
    private let acceptedIcon = "person.crop.circle.badge.checkmark"
    private let openIcon = "person.crop.circle"
    //height of the row
    var height : CGFloat = 105
    //needs an id as an identifier for list
    var id = UUID()
    
    @ObservedObject var selectionManager : SelectionManager
    @ObservedObject var notificationMan : LeadManager
    @State var phoneNumber = ""
    @State var email = ""
    var lead : Lead
    @State var showMoreInfo = false
    
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
                            if lead.notification_state ==
                                notificationType.open.rawValue {
                                Rectangle()
                                    .fill(Color.darkAccent)
                                    .frame(width: 50.0)
                                Image(
                                    systemName: openIcon)
                                    .imageScale(.large)
                                    .foregroundColor(Color.lightAccent)
                            } else if lead.notification_state ==
                                notificationType.accepted.rawValue {
                                Rectangle()
                                    .fill(Color.lightAccent)
                                    .frame(width: 50.0)
                                Image(
                                    systemName: acceptedIcon)
                                    .imageScale(.large)
                                    .foregroundColor(.mid)
                            }else{ //scheduled
                                if lead.notification_value.job_type?
                                    .contains("Estimate") ?? false {
                                    Rectangle()
                                        .fill(Color.lightAccent)
                                        .frame(width: 50.0)
                                    Image(
                                        systemName: "dollarsign.square.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.mid)
                                } else if lead.notification_value.job_type?
                                            .contains("Work") ?? false {
                                    Rectangle()
                                        .fill(Color.lightAccent)
                                        .frame(width: 50.0)
                                    Image(
                                        systemName: "paintbrush.fill")
                                        .imageScale(.large)
                                        .foregroundColor(.mid)
                                }else{
                                    Rectangle()
                                        .fill(Color.lightAccent)
                                        .frame(width: 50.0)
                                    Image(
                                        systemName: "doc")
                                        .imageScale(.large)
                                        .foregroundColor(.mid)
                                }
                            }
                        }
                        //displaying the content on the card
                        VStack(alignment: .leading) {
                            Text(lead.notification_key)
                                    .font(.headline)
                                    .foregroundColor(.darkAccent)
                            Text(Communications.findAddress(
                                    in: lead.notification_value.job_address ?? "")
                                    ?? "No Address Found")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                            HStack{
                                Text(formatDate(lead.notification_date))
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(formatTime(lead.notification_date))
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
                            .stroke((self.id == self.selectionManager.id) ?
                                        Color.blue : Color.mid,
                                    lineWidth:
                                        (self.id == self.selectionManager.id) ?
                                        3 : 1))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .clipShape(RoundedRectangle(cornerRadius: 10)) 
            .sheet(
                isPresented: self.$showMoreInfo,
                content: {
                LeadInfoSheet(
                    images:
                        Communications.findPhotos(
                            in: lead.notification_value.note ?? "")
                        .map({RemoteImage(url: $0)}),
                    lead: cleanNote(in: lead),
                    notificationMan: notificationMan,
                    phoneNumber: lead.notification_value.phone,
                    email: lead.notification_value.email,
                    address: lead.notification_value.job_address)
            })
        }
    }

///formatting functions for lead presentation
extension LeadCardView {
    
    func cleanNote(in lead : Lead) -> Lead{
        var tempLead = lead
        let note = lead.notification_value.note ?? ""
        let regex = try! NSRegularExpression(
            pattern: "Photos:.* Customer Message:")
        let range = NSMakeRange(0, note.count)
        var modString = regex.stringByReplacingMatches(
            in: note,
            options: [],
            range: range,
            withTemplate: "XXX")
        if modString.contains("XXX"){
            modString = modString
                .replacingOccurrences(of: "XXX", with: "Customer Message:")
        }else{
            let regexOne = try! NSRegularExpression(pattern: "Photos:.*")
            let rangeOne = NSMakeRange(0, note.count)
            modString = regexOne.stringByReplacingMatches(
                in: note,
                options: [],
                range: rangeOne,
                withTemplate: "")
        }
        tempLead.notification_value.note = modString
        return tempLead
    }
    
    func formatDate(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =
            defaults.getApplicationType() == .NHanceConnect ?
            "yyyy-MM-dd'T'HH:mm:ss" : "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:str_date)!
        let dateString = date.dayOfWeekWithMonthAndDay
        return dateString
    }
    
    func formatTime(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =
            defaults.getApplicationType() == .NHanceConnect ?
            "yyyy-MM-dd'T'HH:mm:ss" : "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:str_date)!
        let dateString = date.timeOnlyWithPadding
        return dateString
    }
}
