//
//  LoginView.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/23/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Standard Login View

fileprivate let emptyfields_error = "Make sure your contact is correct and all fields are filled."
fileprivate let noUser_error = "Sorry! No user exists with this contact info."
fileprivate let submitbutton_text = "Find Your Franchise"
fileprivate let confirmalert_text = "Is this your franchise?"
fileprivate let cancelbutton_text = "Cancel"
fileprivate let confirmbutton_text = "Confirm"
fileprivate let emailprompt_text = "Enter your franchise email"

struct LoginView: View {
    
    //the view router that hosts this login view
    @ObservedObject var viewRouter: ViewRouter
    //input variables for sheet peak
    @State var firstname = ""
    @State var lastname = ""
    //all
    @State var email = ""
    //show error to user
    @State var showError = false
    @State var showErrorNoUser = false
    //show the action sheet for confirmation
    @State var showActionSheet = false
    @State var showActionSheet_ipad = false
    //output values
    @State var franchise : Franchise?
    //show the home screen
    @State var showHome = false
    //show the two factor auth view
    @State var showCodeView = false
    @State var expectedCode = ""
    
    var body: some View {
        VStack{
            Header(viewRouter: viewRouter, back: false)
            Spacer()
            if defaults.getApplicationType() == .NHanceConnect {
                LoginFields_Nhance(
                    email: $email,
                    showActionSheet_ipad: $showActionSheet_ipad)
            }else if defaults.getApplicationType() == .PeakClients(.any) {
                LoginFields_Peak(
                    firstname: $firstname,
                    lastname: $lastname,
                    email: $email,
                    showActionSheet_ipad: $showActionSheet_ipad)
            }
            //if error is to be shown
            Warning(
                showError: $showError,
                content: emptyfields_error)
            Warning(
                showError: $showErrorNoUser,
                content: noUser_error)
            if (!showActionSheet_ipad) {
            //TODO: these checks are really simple and could be advanced
                if (email.contains("@") &&
                    email.contains(".")){
                    //submission button
                    Button(action:{
                        self.checkForUser()
                    }){
                        Text(submitbutton_text)
                            .foregroundColor(Color.blue)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue)
                    )
                    .onAppear(perform: {
                        self.showError = false
                    })
                }else{
                    //show error button
                    Button(action:{
                        self.showError = true
                    }){
                        Text(submitbutton_text)
                            .foregroundColor(Color.gray)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray)
                    )
                    .opacity(0.5)
                }
            }
            Group{
                Group {
                    if showActionSheet_ipad {
                        Divider()
                            .frame(width: 300)
                        Text(confirmalert_text)
                        Text(franchise?.franchiseTitle ?? "").bold().padding()
                        HStack{
                            Button(action: {
                                self.showActionSheet_ipad = false
                            }, label: {
                                Text(cancelbutton_text)
                            })
                            
                            Button(action:{
                                self.showCodeView = true
                            }){
                                Text(confirmbutton_text)
                                    .foregroundColor(Color.blue)
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue)
                            )
                        }
                    }
                }
                Spacer()
                Spacer()
            }
        }
        //action sheet to confirm franchise
        .actionSheet(isPresented: $showActionSheet){
            ActionSheet(
                title: Text(franchise?.franchiseTitle ?? ""),
                message: Text(confirmalert_text),
                buttons: [
                    .cancel(){},
                    .default(Text(confirmbutton_text)){
                        defaults.setEmail(self.email)
                        showCodeView = true
                    }
                ]
            )
        }
        
        //code view for two factor authentication
        .sheet(isPresented: $showCodeView){
            CodeView(
                viewRouter: self.viewRouter,
                contact: self.email,
                expectedCode: defaults.expectedCode,
                name: firstname + " " + lastname,
                franchise: self.franchise!)
        }
    }
    
    /**
     #Look for franchise in database
     */
    func checkForUser(){
        DatabaseDelegate.getUserForLogin(email: email, completion: {
            rex in
            do {
                if (rex as! [Franchise]).count == 0 {
                    self.showErrorNoUser = true
                    throw ContentError.noUser
                }else{
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        self.showActionSheet = true
                    }else{
                        self.showActionSheet_ipad = true
                    }
                    self.franchise = (rex as! [Franchise])[0]
                    if (self.franchise!.franchiseId == defaults.admin_id){
                        defaults.admin = true
                    }
                    self.expectedCode = franchise!.twoFactor
                    defaults.expectedCode = self.expectedCode
                }
                
            } catch ContentError.noUser {
                printr(ContentError.noUser.rawValue,
                       tag: printTags.error)
            } catch {
                printr(InternalError.unknownError,
                       tag: printTags.error)
            }
        })
    }
}

struct LoginFields_Nhance: View {
    
    @Binding var email : String
    @Binding var showActionSheet_ipad : Bool
    
    var body : some View {
        if !showActionSheet_ipad {
            TextField(emailprompt_text, text: $email)
                .frame(width: 250.0, height: 40.0)
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            Divider().frame(width: 250.0)
        }else{
            Text(email)
                .foregroundColor(Color.gray)
        }
    }
    
}

struct LoginFields_Peak: View {
    
    @Binding var firstname : String
    @Binding var lastname : String
    @Binding var email : String
    @Binding var showActionSheet_ipad : Bool
    
    var body : some View {
        if !showActionSheet_ipad {
            //first and last name input
            TextField("First Name", text: $firstname)
                .frame(width: 250.0, height: 40.0)
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .allowsHitTesting(!showActionSheet_ipad)
            TextField("Last Name", text: $lastname)
                .frame(width: 250.0, height: 40.0)
                .cornerRadius(10)
                .multilineTextAlignment(.center)
            TextField("Enter your franchise email", text: $email)
                .frame(width: 250.0, height: 40.0)
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            Divider()
                .frame(width: 250.0)
        }else{
            Text(firstname)
                .foregroundColor(Color.gray)
            Text(lastname)
                .foregroundColor(Color.gray)
            Text(email)
                .foregroundColor(Color.gray)
        }
    }
}

struct Warning: View {
    
    @Binding var showError : Bool
    var content : String
    
    var body: some View {
        if showError{
            Text(content)
                .foregroundColor(Color.red)
                .padding(.bottom)
        }
    }
}
