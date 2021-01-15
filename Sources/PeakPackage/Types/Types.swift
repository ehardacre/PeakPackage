//
//  Types.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 8/20/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI


//Would be better named Lead types, these are the types that exist
//TODO: this is likely different on the peak studios app
enum notificationType : String {
    case open = "Open"
    case accepted = "Accepted"
    case scheduled = "Scheduled"
    case scheduled_full = "Estimate Scheduled"
}

//order type for woocommerce
enum orderType : String {
    case pending = "wc-pending"
    case processing = "wc-processing"
}


// MARK: Error Types
/**
 # Data Error
 data errors are used to describe problems that happen on the backend sites, not in app.
 */
enum DataError: String, Error {
    case badHook = "The request to the server was rejected"
    case nilResponse = "The value returned from the server was found to be nil"
    case nilDefaults = "One or more user defaults was found to be nil"
    case badFormat = "The value from the database could not be converted to a String"
    case failedRequest = "The request to submit a task or event failed."
}

/**
 # Content Error
 content errors describe situations where the user has made some sort of mistake that should be relayed to them
 */
enum ContentError: String, Error {
    case noUser = "We could not find your user information in our database"
}

/**
 # Internal Error
 internal errors describe errors that are caused by poor programming in app.
 These should hopefully never happen, but nobody's perfect
 */
enum InternalError: String, Error {
    case nilContent = "The value of the content view was found to be nil"
    case viewLoading = "The view is not finished loading"
    case unknownError = "There was an unknown error: "
}

