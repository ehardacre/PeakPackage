//
//  LoginView.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/23/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Standard Login View

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
            
            if try! defaults.getApplicationType() == .NHanceConnect {
                LoginFields_Nhance(email: $email, showActionSheet_ipad: $showActionSheet_ipad)
            }else if try! defaults.getApplicationType() == .PeakClients {
                LoginFields_Peak(firstname: $firstname, lastname: $lastname, email: $email, showActionSheet_ipad: $showActionSheet_ipad)
            }
            
            //if error is to be shown
            
            Warning(showError: $showError, content: "Make sure your contact is correct and all fields are filled.")
            Warning(showError: $showErrorNoUser, content: "Sorry! No user exists with this contact info.")
            
            if (!showActionSheet_ipad) {
            //check that all fields are filled and appropriate
            //TODO: these checks are really simple and could be advanced
            if (email.contains("@") && email.contains(".")){
                
                //submission button
                Button(action:{
                    self.checkForUser()
                }){
                    Text("Find Your Franchise").foregroundColor(Color.blue)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue)
                ).onAppear(perform: {
                    self.showError = false
                })
                
            }else{
                
                //show error button
                Button(action:{
                    self.showError = true
                }){
                    Text("Find Your Franchise").foregroundColor(Color.gray)
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
                        Divider().frame(width: 300)
                        Text("Is this your franchise?")
                        Text(franchise?.franchiseTitle ?? "").bold().padding()
                        HStack{
                            Button(action: {
                                self.showActionSheet_ipad = false
                            }, label: {
                                Text("Cancel")
                            })
                            
                            Button(action:{
                                self.showCodeView = true
                            }){
                                Text("Confirm").foregroundColor(Color.blue)
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
        
        }//VSTACK end
            
        //action sheet to confirm franchise
        .actionSheet(isPresented: $showActionSheet){
            ActionSheet(
                title: Text(franchise?.franchiseTitle ?? ""),
                message: Text("Is this your franchise?"),
                buttons: [
                    .cancel(){print("Cancelled")},
                    .default(Text("Confirm")){
                        defaults.setEmail(self.email)
                        showCodeView = true
                    }
                ]
            )
        }
        
        //code view for two factor authentication
        .sheet(isPresented: $showCodeView){
            CodeView(viewRouter: self.viewRouter, expectedCode: defaults.expectedCode, franchise: self.franchise!)
        }
        
    }
    
    /**
     #Look for franchise in database
     */
    func checkForUser(){

        
        let json: [String: Any] = JsonFormat.getUserFromEmail(email: email).format()
        
        
        DatabaseDelegate.performRequest(with: json, ret: returnType.franchiseList, completion: {
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
                printr(ContentError.noUser.rawValue, tag: printTags.error)
            } catch {
                printr(InternalError.unknownError, tag: printTags.error)
            }
        })
    }
}

struct LoginFields_Nhance: View {
    
    @Binding var email : String
    @Binding var showActionSheet_ipad : Bool
    
    var body : some View {
        
        if !showActionSheet_ipad {
            
            //first and last name input

            TextField("Enter your franchise email", text: $email)
                .frame(width: 250.0, height: 40.0)
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            Divider().frame(width: 250.0)

        }else{
            Text(email).foregroundColor(Color.gray)
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
            Divider().frame(width: 250.0)

        }else{
            Text(firstname).foregroundColor(Color.gray)
            Text(lastname).foregroundColor(Color.gray)
            Text(email).foregroundColor(Color.gray)
        }
    }
    
}

struct Warning: View {
    @Binding var showError : Bool
    var content : String
    var body: some View {
        if showError{
    
            Text(content).foregroundColor(Color.red).padding(.bottom)
            
        }
    }
}
