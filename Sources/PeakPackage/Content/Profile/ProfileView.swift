//
//  ProfileView.swift
//  Peak Client
//
//  Created by Ethan Hardacre  on 6/30/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI
import Introspect

struct ProfileView: View {
    
    @State var address = ""
    @State var prev_address = ""
    @State var city = ""
    @State var prev_city = ""
    @State var zip = ""
    @State var prev_zip = ""
    @State var state = ""
    @State var prev_state = ""
    @State var phone = ""
    @State var prev_phone = ""
    @State var email = ""
    @State var prev_email = ""
    @State var editting = false
    @State var confirmation = false
    @Binding var showing : Bool
    @ObservedObject var manager : ProfileManager
    
    var body: some View {
        GeometryReader{
            geo in
            NavigationView{
                List{
                    if defaults.admin {
                        Button(action: {
                            DatabaseDelegate.testNotification()
                        }, label: {
                            HStack{
                                Image(systemName: "note.text")
                                    .foregroundColor(Color.darkAccent)
                                Text("Test Notifications")
                                    .ButtonText()
                            }
                        })
                        .RoundRectButton()
                        Divider()
                        SwitchProfileView(
                            profiles: manager.profiles,
                            profileManager: manager)
                            .frame(height: 400)
                            .cornerRadius(10.0)
                            .buttonStyle(PlainButtonStyle())
                        LogView(logs: defaults.getLogs())
                            .frame(height: 400)
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            defaults.logout()
                        }){
                            Text("Logout")
                                .foregroundColor(.lightAccent)
                        }
                        .frame(width: 100)
                        .padding(20)
                        .background(Color.darkAccent)
                        .cornerRadius(30)
                        Spacer()
                    }
                }
                .listStyle(SidebarListStyle())
                .onAppear{
                    self.loadClientInfo()
                }
                .navigationBarTitle(
                    Text(defaults.franchiseName() ?? ""),
                    displayMode: .inline
                )
                .navigationBarItems(leading:
                    Button(action: {
                        showing = false
                    }){
                    Image(systemName: "control")
                        .imageScale(.large)
                        .foregroundColor(Color.darkAccent)
                        .rotationEffect(Angle(degrees: 180))
                    }
                    ,trailing:
                        Button(action: {
                            if self.editting {
                                self.confirmation = true
                            }else{
                                self.editting = true
                            }
                        }){
                            if self.editting{
                                Text("Save")
                            }else{
                                Image(systemName: "square.and.pencil")
                                    .imageScale(.large)
                                    .foregroundColor(Color.darkAccent)
                            }
                })
                .background(Color.clear)
            }
            .background(Color.clear)
            .stackOnlyNavigationView()
        }
        .alert(
            isPresented: $confirmation,
            content: {
            Alert(
                title: Text("Save Changes?"),
                message: Text("Make sure your information is correct. Saving your changes here will change the information on your website as well."),
                primaryButton:
                    .default(Text("Confirm"),
                             action: {
                        self.saveClientInfo()
                        self.confirmation = false
                        self.editting = false
                             }),
                secondaryButton: .cancel())
        })
    }
    
    /**
     # Save Client Information
        saves the updated client information to the PSClients server
     */
    func saveClientInfo(){
        let id = defaults.franchiseId()!
        //format the json for updating client info
        let json = JsonFormat.setUser(
            id: id,
            address:
                self.address != self.prev_address ?
                self.address : nil,
            city:
                self.city != self.prev_city ?
                self.city : nil,
            state:
                self.state != self.prev_state ?
                self.state : nil,
            zip:
                self.zip != self.prev_zip ?
                self.zip : nil,
            phone:
                self.phone != self.prev_phone ?
                self.phone : nil,
            email:
                self.email != self.prev_email ?
                self.email : nil)
            .format()
        DatabaseDelegate.performRequest(
            with: json,
            ret: returnType.string,
            completion: {
            _ in
        })
    }
    
    /**
     # Load Client Information
     loads the client info that is currently on the PSClients server
     */
    func loadClientInfo(){
        let id = defaults.franchiseId();
        if id != nil{
            let json = JsonFormat.getUser(id: id!).format()
            DatabaseDelegate.performRequest(
                with: json,
                ret: returnType.user,
                completion: {
                rex in
                let user = rex as! UserType
                self.address = user.address
                self.city = user.city
                self.state = user.state
                self.zip = user.zip
                self.phone = user.phone
                self.email = user.email
                self.prev_address = self.address
                self.prev_city = self.city
                self.prev_zip = self.zip
                self.prev_state = self.state
                self.prev_email = self.email
                self.prev_phone = self.phone
            })
        }
    }
    
    
}


struct ProfileElement: View {
    
    var editting : Bool = false
    var key : String = ""
    @Binding var value: String
    
    var body: some View {
        GeometryReader{
            geo in
            VStack{
                HStack{
                    Text(self.key)
                        .bold()
                        .padding(.vertical)
                    Spacer()
                    if self.editting{
                        TextField(
                            self.value,
                            text: self.$value)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color.black.opacity(0.6))
                    }else{
                        Text(self.value)
                            .padding(.vertical)
                    }
                }
                .frame(width: geo.size.width)
            }
        }
        .frame(height: 40)
    }
}

struct MultiElement: View {
    
    var editting : Bool = false
    var key : String = ""
    @Binding var address : String
    @Binding var city : String
    @Binding var state : String
    @Binding var zip : String
    
    var body: some View {
        VStack(alignment: .center){
            Divider()
            ProfileElement(
                editting: editting,
                key: "Address",
                value: $address)
                .padding(.horizontal)
            ProfileElement(
                editting: editting, key: " ",
                value: $city)
                .padding(.horizontal)
            ProfileElement(
                editting: editting,
                key: " ",
                value: $state)
                .padding(.horizontal)
            ProfileElement(
                editting: editting,
                key: " ",
                value: $zip)
                .padding(.horizontal)
            Divider()
        }
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
    
}
