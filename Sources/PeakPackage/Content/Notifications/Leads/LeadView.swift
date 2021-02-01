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
    
    //needs an id as an identifier for list
    var id = UUID()
    @ObservedObject var selectionManager : SelectionManager
    @ObservedObject var notificationMan : NotificationManager
    
    private let calendarIcon = "calendar"
    private let acceptedIcon = "person.crop.circle.badge.checkmark"
    private let openIcon = "person.crop.circle"
    
    @State var phoneNumber = ""
    @State var email = ""
    
    var lead : Lead
    
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
                            if lead.notification_state == notificationType.open.rawValue {
                                Rectangle().fill(Color.darkAccent).frame(width: 50.0)
                                Image(systemName: openIcon).imageScale(.large).foregroundColor(Color.lightAccent)
                            } else if lead.notification_state == notificationType.accepted.rawValue{
                                Rectangle().fill(Color.lightAccent).frame(width: 50.0)
                                Image(systemName: acceptedIcon).imageScale(.large).foregroundColor(.mid)
                                
                            }else{ //scheduled
                                
                                if lead.notification_value.job_type?.contains("Estimate") ?? false{
                                    
                                    Rectangle().fill(Color.lightAccent).frame(width: 50.0)
                                    Image(systemName: "dollarsign.square.fill").imageScale(.large).foregroundColor(.mid)
                                    
                                } else if lead.notification_value.job_type?.contains("Work") ?? false{
                                    
                                    Rectangle().fill(Color.lightAccent).frame(width: 50.0)
                                    Image(systemName: "paintbrush.fill").imageScale(.large).foregroundColor(.mid)
                                
                                }else{
                                    
                                    Rectangle().fill(Color.lightAccent).frame(width: 50.0)
                                    Image(systemName: "questionmark.diamond.fill").imageScale(.large).foregroundColor(.mid)
                                    
                                }
                                
                            }
                            
                        //ZSTACK end
                        }
                        
                        //displaying the content on the card
                            VStack(alignment: .leading) {
                                
                                Text(lead.notification_key)
                                        .font(.headline)
                                        .foregroundColor(.darkAccent)
                                Text(findAddress(in: lead.notification_value.job_address ?? "") ?? "No Address Found")
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
                                
                            //VSTACK end
                            }
                        
                        Spacer()
                        
                        
                        
                    //HSTACK
                    }.frame(width: geo.size.width, height: self.height)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke((self.id == self.selectionManager.id) ? Color.blue : Color.mid, lineWidth: (self.id == self.selectionManager.id) ? 3 : 1))
                        //OVERLAY end
                        )
                .onTapGesture(count: 1, perform: {
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
//                LeadInfoSheet(lead: lead, notificationMan: notificationMan, phoneNumber: self.findPhoneNumber(in: lead.notification_value), email: self.findEmail(in: lead.notification_value), address: self.findAddress(in: lead.notification_value))
                LeadInfoSheet(lead: cleanNote(in: lead), notificationMan: notificationMan, phoneNumber: lead.notification_value.phone, email: lead.notification_value.email, address: lead.notification_value.job_address, imageURLs: self.findPhotos(in: lead.notification_value.note ?? ""))
            })
        }
    
    }

//idk if these functions really belong here
extension LeadCardView {
    
    static func makeCall(to phone: String){
        let extras = CharacterSet(charactersIn: "-() ")

        //TODO Include in peak client app
        var cleanString = phone.replaceCharactersFromSet(characterSet: extras, replacementString: "")

        let tel = "tel://"
        var formattedString = tel + cleanString
        let url: NSURL = URL(string: formattedString)! as NSURL

        UIApplication.shared.open(url as URL)
    }
    
    static func makeText(to phone: String){
        let extras = CharacterSet(charactersIn: "-() ")

        //TODO Include in peak client app
        var cleanString = phone.replaceCharactersFromSet(characterSet: extras, replacementString: "")
        
        let sms : String = "sms:+1\(cleanString)&body="
        let smsUrl = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: smsUrl)!, options: [:], completionHandler: nil)
    }
    
//    static func makeEmail(to email: String){
//        isShowingMailView = true
//    }
    
    func findPhoneNumber(in content : String) -> String?{
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: content, range: NSRange(content.startIndex..., in: content))
            for match in matches {
                if match.resultType == .phoneNumber {
                    let range = Range(match.range, in: content)
                    if range != nil{
                        return content.substring(with: range!)
                    }else{
                        return nil
                    }
                }
            }
        }catch{
            printr(error, tag: printTags.error)
        }
        return nil
    }
    
    func findEmail(in content : String) -> String?{
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+")
        var match = regex.firstMatch(in: content,range: NSRange(content.startIndex..., in: content))
        if match != nil {
            let range = Range(match!.range, in: content)
            if range != nil{
                return content.substring(with: range!)
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func findAddress(in content : String) -> String?{
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
            let matches = detector.matches(in: content, range: NSRange(content.startIndex..., in: content))
            for match in matches {
                if match.resultType == .address {
                    let range = Range(match.range, in: content)
                    if range != nil{
                        return content.substring(with: range!)
                    }else{
                        return nil
                    }
                }
            }
        }catch{
            printr(error, tag: printTags.error)
        }
        return nil
        
    }
    
    func findPhotos(in content : String) -> [String]{
        var photoURLs : [String] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: content, range: NSRange(content.startIndex..., in: content))
            for match in matches {
                if match.resultType == .link {
                    let range = Range(match.range, in: content)
                    if range != nil{
                        photoURLs.append(content.substring(with: range!))
                    }else{
                        printr("no photos")
                        return photoURLs
                    }
                }
            }
        }catch{
            printr(error, tag: printTags.error)
        }
        return photoURLs
    }
    
    func cleanNote(in lead : Lead) -> Lead{
        
        var tempLead = lead
        
        var note = lead.notification_value.note ?? ""
        
        let regex = try! NSRegularExpression(pattern: "Photos:.* Customer Message:")
        let range = NSMakeRange(0, note.count)
        var modString = regex.stringByReplacingMatches(in: note, options: [], range: range, withTemplate: "XXX")
        
        if modString.contains("XXX"){
            modString = modString.replacingOccurrences(of: "XXX", with: "Customer Message:")
        }else{
            
            let regexOne = try! NSRegularExpression(pattern: "Photos:.*")
            let rangeOne = NSMakeRange(0, note.count)
            modString = regexOne.stringByReplacingMatches(in: note, options: [], range: rangeOne, withTemplate: "")
            
        }
        
        tempLead.notification_value.note = modString
        
        return tempLead
    }
    
    func formatDate(_ str_date: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        
        //date = date.toLocalTime()
        
        var dateString = date.dayOfWeekWithMonthAndDay
    
        return dateString
    }
    
    func formatTime(_ str_date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var date = dateFormatter.date(from:str_date)!
        
        //date = date.toLocalTime()
        
        var dateString = date.timeOnlyWithPadding
        
    
        return dateString
    }
}
