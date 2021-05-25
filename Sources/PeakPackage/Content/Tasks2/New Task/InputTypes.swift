//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/31/21.
//

import Foundation
import SwiftUI

enum AutoFormInputType{
    case ShortString
    case LongString
    case Int
    case Date
    case Time
    case Image
    case Multichoice(options : [String])
    
    init(type: String) {
        switch type{
        case "ShortString":
            self = .ShortString
        case "LongString":
            self = .LongString
        case "Int":
            self = .Int
        case "Date":
            self = .Date
        case "Time":
            self = .Time
        case "Image":
            self = .Image
        case let str where str.contains("Multichoice"):
            self = .Multichoice(options: MultiInputCardView.makeChoiceList(text: type))
        default:
            fatalError("No Autoform type")
        }
    }
    
    func view(id: UUID, label: String, prompt: String, taskManager: TaskManager2) -> AnyView {
        switch self{
        case .ShortString:
            return AnyView(TextInputCardView(
                            id: id,
                            title: label,
                            placeholder: prompt))
        case .LongString:
            return AnyView(TextInputCardView(
                            id: id,
                            numLines: 3,
                            title: label,
                            placeholder: prompt))
        case .Int:
            return AnyView(TextInputCardView(
                            id: id,
                            title: label,
                            placeholder: prompt,
                            integer: true))
        case .Date:
            return AnyView(DateInputCardView(
                            id: id,
                            title: label,
                            prompt: prompt))
        case .Time:
            return AnyView(TimeInputCardView(
                            id: id, taskManager: taskManager,
                            title: label,
                            prompt: prompt))
            //Multichoice(choice 1, choice 2)
        case .Multichoice(let options):
            return AnyView(MultiInputCardView(
                            id: id,
                            title: label,
                            prompt: prompt,
                            choices: options))
        default: //.Image
            return AnyView(ImageInputCardView(
                            id: id,
                            title: label,
                            prompt: prompt))
        }
    }
    
    func string() -> String {
        switch self{
        case .Multichoice(let options):
            return multichoice(with: options)
        case .ShortString:
            return "ShortString"
        case .LongString:
            return "LongString"
        case .Int:
            return "Int"
        case .Date:
            return "Date"
        case .Time:
            return "Time"
        default: //.Image
            return "Image"
        }
    }
    
    func databaseID() -> String {
        switch self {
        case .Multichoice( _):
            return "6"
        case .ShortString:
            return "1"
        case .LongString:
            return "2"
        case .Int:
            return "3"
        case .Date:
            return "4"
        case .Time:
            return "7"
        default:
            return "5"
        }
    }
    
    func imageName() -> String {
        switch self{
        case .Multichoice( _):
            return "list.bullet.rectangle"
        case .ShortString:
            return "bubble.left"
        case .LongString:
            return "plus.bubble"
        case .Int:
            return "number.square"
        case .Date:
            return "calendar"
        case .Time:
            return "clock.fill"
        default:
            return "photo"
        }
    }
    
    private func multichoice(with options: [String]) -> String {
        if options.isEmpty {
            return "Multichoice"
        }
        var str = "Multichoice("
        for opt in options{
            str = str + opt + ","
        }
        return str.dropLast() + ")"
    }
}
