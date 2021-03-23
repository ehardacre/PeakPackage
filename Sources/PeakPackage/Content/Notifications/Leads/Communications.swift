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

struct Communications{
    
    static func makeCall(to phone: String){
        let extras = CharacterSet(charactersIn: "-() ")
        var cleanString = phone.replaceCharactersFromSet(
            characterSet: extras,
            replacementString: "")
        let tel = "tel://"
        var formattedString = tel + cleanString
        let url: NSURL = URL(string: formattedString)! as NSURL
        UIApplication.shared.open(url as URL)
    }
    
    static func makeText(to phone: String){
        let extras = CharacterSet(charactersIn: "-() ")
        var cleanString = phone.replaceCharactersFromSet(
            characterSet: extras,
            replacementString: "")
        let sms : String = "sms:+1\(cleanString)&body="
        let smsUrl = sms.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(
            URL.init(string: smsUrl)!,
            options: [:],
            completionHandler: nil)
    }
    
    static func findPhoneNumber(in content : String) -> String?{
        do {
            let detector = try NSDataDetector(
                types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(
                in: content,
                range: NSRange(content.startIndex..., in: content))
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
    
    static func findEmail(in content : String) -> String?{
        let regex = try! NSRegularExpression(
            pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]+")
        var match = regex.firstMatch(
            in: content,
            range: NSRange(content.startIndex..., in: content))
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
    
    static func findAddress(in content : String) -> String?{
        do {
            let detector = try NSDataDetector(
                types: NSTextCheckingResult.CheckingType.address.rawValue)
            let matches = detector.matches(
                in: content,
                range: NSRange(content.startIndex..., in: content))
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
    
    static func findPhotos(in content : String) -> [String]{
        var photoURLs : [String] = []
        do {
            let detector = try NSDataDetector(
                types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(
                in: content,
                range: NSRange(content.startIndex..., in: content))
            for match in matches {
                if match.resultType == .link {
                    let range = Range(match.range, in: content)
                    if range != nil{
                        photoURLs.append(content.substring(with: range!))
                    }else{
                        return photoURLs
                    }
                }
            }
        }catch{
            printr(error, tag: printTags.error)
        }
        return photoURLs
    }
}
