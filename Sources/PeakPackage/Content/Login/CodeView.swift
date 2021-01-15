//
//  CodeView.swift
//  Peak Client
//
//  Created by Ethan Hardacre  on 7/1/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI
import Firebase

//MARK: Code View

struct CodeView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    //the code that the user enters and code expected
    @State var codeInput = ""
    @State var expectedCode = ""
    
    //show error with code
    @State var showError = false
    
    //franchise information
    @State var franchise : Franchise
    
    var body: some View {
        VStack{
            
            Header(viewRouter: viewRouter)
            
            //Spacer()
        
            //if show error highlight the instructions
            if defaults.admin {
                Text("Enter the test password given.")
            }else if showError{
                Text("Enter the 5-digit code that was sent to your phone or email.").font(.footnote).foregroundColor(Color.red)
            }else{
                Text("Enter the 5-digit code that was sent to your phone or email.").font(.footnote)
            }
            
            TextField("Code", text: $codeInput).keyboardType(.numberPad)
                .padding(.all)
                .multilineTextAlignment(.center)
            Divider().frame(width: 300)
            
            //check that code input is proper length
            if codeInput.count == 5{
                //highlight submit button
                Button(action:{ self.checkCode() }){
                    Text("Submit").foregroundColor(Color.blue)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue)
                        .frame(width: 200)
                )
                .frame(width: 200)
            }else{
                //gray out submit button
                Button(action:{
                    self.showError = true
                }){
                    Text("Submit")
                        .foregroundColor(Color.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray)
                        .frame(width: 200)
                )
                    .opacity(0.5)
                    .frame(width: 200)
            }
            
            //try again button
            Button(action:{
                //TODO: send a new code
            }){
                Text("Didn't recieve a code? Try again.")
                    .foregroundColor(Color.blue)
                    .font(.footnote)
                    .padding(.all)
            }
            
            Spacer()
            
        //VSTACK end
        }
    }
    
    /**
     #checkCode - verify that the codes match
     if codes match then the user is Logged in!!
     */
    func checkCode(){
        self.showError = false
        printr("checking code...")
        printr(expectedCode)
        if codeInput == expectedCode || ( defaults.admin && codeInput == "63070" ){
            printr("logging in...")
            defaults.signIn()
            defaults.franchiseId(value: self.franchise.franchiseId)
            defaults.franchiseName(value: self.franchise.franchiseTitle)
            defaults.setFranchiseURL(self.franchise.franchiseURL)
            if defaults.getNotificationToken() != nil {
                Firebase.Auth.auth().signIn(withEmail: defaults.getEncodedEmail(), password: "PeakClient", completion: { data, error in
                    if error != nil {
                        Firebase.Auth.auth().createUser(withEmail: defaults.getEncodedEmail() , password: "PeakClient", completion: { data, error in
                                Firebase.Messaging.messaging().subscribe(toTopic: "PeakClients")
                                let id = defaults.franchiseId() ?? "0"
                                Firebase.Analytics.setUserProperty(id, forName: "KanbanID")
                                Firebase.Messaging.messaging().subscribe(toTopic: "nhance"+defaults.franchiseId()!)
                                Firebase.Messaging.messaging().subscribe(toTopic: defaults.getTopics())
                            })
                    }
                })
            }
            //go to content
            self.viewRouter.goTo(page: LoginPages.content)
        }
    }
}
