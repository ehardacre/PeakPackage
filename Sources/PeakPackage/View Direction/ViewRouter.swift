//
//  ViewRouter.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/23/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Page Types
/**
 # Pages
 describes the page types that the View Router Manages
 */
public enum LoginPages {
    case standardLogin
    case content
    case noPage
}

//MARK: View Router
/**
 # View Router
 The view router extends observable object and is used to track which page is being shown mainly in the login sequence
 */
open class ViewRouter: ObservableObject {
    
    //the current and previous page that the app is on
    @Published open var currentPage: LoginPages = LoginPages.noPage
    {
        didSet {
            printr("changed currentPage")
        }
        willSet(newVal) {
            printr("changing currentPage")
            goTo(page: newVal)
        }
    }
    private var previousPages : Stack<LoginPages> = []
    
    
    //Initializer for a view router
    public init(){
        //get whether the user has signed in before
        let signIn = defaults.signedIn()
        if signIn {
            //admin shortcut
            if defaults.franchiseId() == defaults.admin_id {
                defaults.admin = true
            }
            currentPage = LoginPages.content
        } else {
            //user is not signed in, go to login
            currentPage = LoginPages.standardLogin
        }
    }
    
    
    /**
        #go To
     - Parameter page: the page that will be transitioned to by the view router
     */
    open func goTo(page: LoginPages){
        if page == LoginPages.noPage{
            return
        }
        //Make sure that all of the necessary login information has been collected
        do{
            if page == LoginPages.content {
                printr("going to content")
                if !defaults.allSet(){
                    throw DataError.nilDefaults
                }
            }
            printr("changing page")
            //transition and set previous page for back button
            previousPages.push(currentPage)
            //currentPage = page
        } catch DataError.nilDefaults {
            printr(DataError.nilDefaults.rawValue, tag: printTags.error)
        } catch {
            printr(InternalError.unknownError.rawValue + error.localizedDescription, tag: printTags.error)
        }
    }
    
    /**
    # Back
     goes to the previous page as listed in the pages  stack
     */
    func back(){
        //not at the bottom of the stack
        if !previousPages.isEmpty {
            //pop the previous page off the stack
            currentPage = previousPages.pop()!
        }
    }
}

