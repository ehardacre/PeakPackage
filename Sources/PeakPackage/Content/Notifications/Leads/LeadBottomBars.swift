//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/19/21.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

struct BottomBar_NHance : View{
    
    @State var email : String?
    @State var phoneNumber : String?
    
    private let phoneIcon = "phone.fill"
    private let textIcon = "text.bubble.fill"
    private let emailIcon = "envelope.fill"
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body : some View {
        HStack{
            HStack{
                HStack{
                    Spacer()
                    Image(systemName: phoneIcon)
                        .imageScale(.large)
                        .foregroundColor(.lightAccent)
                    Spacer()
                }
                .padding(20)
                .background(Color.darkAccent)
                .clipShape(Capsule())
                .opacity(phoneNumber == nil ? 0.2 : 1.0)
                .onTapGesture {
                    if phoneNumber != nil{
                        Communications.makeCall(to: phoneNumber!)
                    }
                }
                HStack{
                    Spacer()
                    Image(systemName: textIcon)
                        .imageScale(.large)
                        .foregroundColor(.lightAccent)
                    Spacer()
                }
                .padding(20)
                .background(Color.darkAccent)
                .clipShape(Capsule())
                .opacity(phoneNumber == nil ? 0.2 : 1.0)
                .onTapGesture {
                    if phoneNumber != nil{
                        Communications.makeText(to: phoneNumber!)
                    }
                }
                //email
                HStack{
                    Spacer()
                    Image(systemName: emailIcon)
                        .imageScale(.large)
                        .foregroundColor(.lightAccent)
                    Spacer()
                }
                .padding(20)
                .background(Color.darkAccent)
                .clipShape(Capsule())
                .opacity(
                        email == nil ||
                        !MFMailComposeViewController.canSendMail() ?
                        0.2 : 1.0)
                .onTapGesture {
                    if email != nil &&
                        MFMailComposeViewController.canSendMail(){
                        isShowingMailView = true
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(
                isShowing: self.$isShowingMailView,
                result: self.$result,
                email: self.email!)
        }
    }
}

struct BottomBar_Peak : View{
    
    private let phoneIcon = "phone.fill"
    private let textIcon = "text.bubble.fill"
    private let emailIcon = "envelope.fill"
    private let starIcon = "star.fill"
    private let nostarIcon = "star"
    
    @State var id : String
    @State var state_str : String
    @State var state : notificationType = notificationType.read
    @State var parent : LeadInfoSheet
    @State var email : String?
    @State var phoneNumber : String?
    @State var confirmTrash = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body : some View {
        HStack{
            
            //star
            HStack{
                Spacer()
                Image(
                    systemName:
                        state == notificationType.starred ?
                        starIcon : nostarIcon)
                    .imageScale(.large)
                    .foregroundColor(
                        state == notificationType.starred ?
                            .yellow : .lightAccent)
                Spacer()
            }
            .padding(20)
            .background(Color.darkAccent)
            .clipShape(Capsule())
            .onTapGesture {
                if state == notificationType.starred {
                    state = notificationType.read
                }else{
                    state = notificationType.starred
                }
            }
            //phone call
            HStack{
                Spacer()
                Image(systemName: phoneIcon)
                    .imageScale(.large)
                    .foregroundColor(.lightAccent)
                Spacer()
            }
            .padding(20)
            .background(Color.darkAccent)
            .clipShape(Capsule())
            .opacity(phoneNumber == nil ? 0.2 : 1.0)
            .onTapGesture {
                if phoneNumber != nil{
                    Communications.makeCall(to: phoneNumber!)
                    state = notificationType.called
                }
            }
            //email
            HStack{
                Spacer()
                Image(systemName: emailIcon)
                    .imageScale(.large)
                    .foregroundColor(.lightAccent)
                Spacer()
            }
            .padding(20)
            .background(Color.darkAccent)
            .clipShape(Capsule())
            .opacity(
                email == nil || !MFMailComposeViewController.canSendMail() ?
                    0.2 : 1.0)
            .onTapGesture {
                if email != nil &&
                    MFMailComposeViewController.canSendMail(){
                    isShowingMailView = true
                    state = notificationType.emailed
                }
            }
            //delete
            HStack{
                Spacer()
                Image(systemName: "trash")
                    .imageScale(.large)
                    .foregroundColor(.darkAccent)
                Spacer()
            }
            .padding(20)
            .background(Color.clear)
            .clipShape(Capsule())
            .onTapGesture {
                confirmTrash = true
            }
        }
        .onAppear{
            switch state_str{
            case "emailed":
                state = notificationType.emailed
            case "called":
                state = notificationType.called
            case "starred":
                state = notificationType.starred
            default:
                state = notificationType.read
            }
        }
        .onDisappear{
            DatabaseDelegate.updatePeakLeads(
                id: id,
                state: state.rawValue,
                completion: {
                    rex in
                })
        }
        .alert(
            isPresented: $confirmTrash,
            content: {
                Alert(
                    title:
                        Text("Are you sure?")
                            .font(.title3),
                    message:
                        Text("You will be deleting this lead.")
                            .font(.footnote) ,
                    primaryButton:
                        .cancel(),
                    secondaryButton:
                        .destructive(Text("Delete")){
                            state = notificationType.deleted
                            parent.dismiss()
                        }
                    )
            })
        .sheet(
            isPresented: $isShowingMailView) {
                MailView(
                    isShowing: self.$isShowingMailView,
                    result: self.$result,
                    email: self.email!)
            }
    }
}
