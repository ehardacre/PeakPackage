//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/24/21.
//

import Foundation
import SwiftUI

let formPub = NotificationCenter.default.publisher(for: Notification.Name("FormSubmit"))

struct AutoForm : Codable {
    
    var id = UUID()
    var title : String
    var subtitle : String
    var elements : [AutoFormElement]
    
}

struct AutoFormElement : Codable {
    
    var id = UUID()
    var label : String
    var prompt : String
    var input : String
    
}

extension AutoFormElement {
    
    func inputView() -> AnyView {

        switch self.input{
        case "ShortString":
            return AnyView(TextInputCardView(
                            id: self.id,
                            title: self.label,
                            placeholder: self.prompt))
        case "LongString":
            return AnyView(TextInputCardView(
                            id: self.id,
                            numLines: 3,
                            title: self.label,
                            placeholder: self.prompt))
        case "Int":
            return AnyView(EmptyView())
        case "Date":
            return AnyView(EmptyView())
        case "Multichoice":
            return AnyView(EmptyView())
        case "Image":
            return AnyView(EmptyView())
        default:
            return AnyView(EmptyView())
        }

    }
    
}

struct TextInputCardView : View{
    
    var id : UUID
    @State var numLines = 1
    @State var title : String
    @State var placeholder : String
    @State var input = ""
    
    var body : some View {
        ZStack{
            TextEditor(text: $input)
                .cornerRadius(20)
                .onTapGesture {
                    self.placeholder = ""
                }
            Text(placeholder)
                .Caption()
        }
        .frame(height: CGFloat(numLines) * 50)
        .cornerRadius(20)
        .onReceive(formPub, perform: { _ in
            NotificationCenter.default.post(
                name: Notification.Name("ElementValue"),
                object: ["input" :  input, "id" : id, "key" : title])
        })
    }
}

struct TextInputCardView_Preview : PreviewProvider{
    static var previews : some View{
        ZStack{
            Color.mid
            TextInputCardView(id: UUID(), title: "key", placeholder: "Enter the service you'd like to add")
        }
    }
}
