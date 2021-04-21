//
//  CodeView.swift
//  Peak Client
//
//  Created by Ethan Hardacre  on 7/1/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Code View
struct CodeView: View {
    
    private let adminpass_prompt = "Enter the test password given."
    private let pass_prompt = "Enter the 5-digit code that was sent to your phone or email."
    
    @ObservedObject var viewRouter: ViewRouter
    
    //the code that the user enters and code expected
    @State var codeInput = ""
    @State var expectedCode = ""
    @State var name = ""
    //show error with code
    @State var showError = false
    //franchise information
    @State var franchise : Franchise
    
    var body: some View {
        ZStack{
            VStack{
                Header(viewRouter: viewRouter)
                Spacer()
            }
            VStack{
                Spacer()
                //if show error highlight the instructions
                if defaults.admin {
                    Text(adminpass_prompt)
                }else if showError{
                    Text(pass_prompt)
                        .font(.footnote)
                        .foregroundColor(Color.red)
                }else{
                    Text(pass_prompt)
                        .font(.footnote)
                }
                TextField("Code", text: $codeInput)
                    .keyboardType(.numberPad)
                    .padding(.all)
                    .multilineTextAlignment(.center)
                Divider()
                    .frame(width: 300)
                //check that code input is proper length
                if codeInput.count == 5{
                    //highlight submit button
                    Button(action:
                            {
                                self.checkCode()
                            })
                    {
                        Text("Submit")
                            .foregroundColor(Color.blue)
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
                    Button(action:
                            {
                        self.showError = true
                            })
                    {
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
                    #warning("TODO send a new code")
                }){
                    Text("Didn't recieve a code? Try again.")
                        .foregroundColor(Color.blue)
                        .font(.footnote)
                        .padding(.all)
                }
                Spacer()
            }
    }
    }
    
    /**
     #checkCode - verify that the codes match
     if codes match then the user is Logged in!!
     */
    func checkCode(){
        self.showError = false
        if
            codeInput == expectedCode ||
                ( defaults.admin &&
                    codeInput == "63070" )
        {
            defaults.signIn()
            if self.name != "" {
                defaults.username(value: self.name)
            }
            defaults.franchiseId(value: self.franchise.franchiseId)
            defaults.franchiseName(value: self.franchise.franchiseTitle)
            defaults.setFranchiseURL(self.franchise.franchiseURL)
            if defaults.getNotificationToken() != nil{
                if defaults.getApplicationType() == .NHanceConnect{
                    #warning("TODO move all to db delegate")
                    let json = JsonFormat.setNotificationToken(
                        token: defaults.getNotificationToken()!,
                        category: "nhance"+defaults.franchiseId()!)
                        .format()
                    DatabaseDelegate.performRequest(
                        with: json,
                        ret: returnType.string,
                        completion:
                            {
                                rex in
                            })
                    let json2 = JsonFormat.setNotificationToken(
                        token: defaults.getNotificationToken()!,
                        category: "nhancebackground")
                        .format()
                    DatabaseDelegate.performRequest(
                        with: json2,
                        ret: returnType.string,
                        completion:
                            {
                                rex in
                            })
                }else if defaults.getApplicationType() == .PeakClients{
                    let json = JsonFormat.setNotificationToken(
                        token: defaults.getNotificationToken()!,
                        category: "peak"+defaults.franchiseId()!)
                        .format()
                    DatabaseDelegate.performRequest(
                        with: json,
                        ret: returnType.string,
                        completion:
                            {
                                rex in
                            })
                }
            }else{
                printr("Notification Token Nil")
            }
            //go to content
            viewRouter.currentPage = LoginPages.content
        }
    }
}
