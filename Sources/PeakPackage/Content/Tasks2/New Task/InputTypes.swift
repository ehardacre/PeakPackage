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
        case "Image":
            self = .Image
        case let str where str.contains("Multichoice"):
            self = .Multichoice(options: MultiInputCardView.makeChoiceList(text: type))
        default:
            fatalError("No Autoform type")
        }
    }
    
    func view(id: UUID, label: String, prompt: String) -> AnyView {
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
            //Multichoice(choice 1, choice 2)
        case .Multichoice(let options):
            return AnyView(MultiInputCardView(
                            id: id,
                            title: label,
                            prompt: prompt,
                            choices: options))
        case .Image:
            return AnyView(ImageInputCardView(
                            id: id,
                            title: label,
                            prompt: prompt))
        default:
            return AnyView(EmptyView())
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
        case .Image:
            return "Image"
        default:
            return ""
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
