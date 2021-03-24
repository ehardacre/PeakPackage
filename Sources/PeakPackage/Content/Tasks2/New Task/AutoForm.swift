//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/24/21.
//

import Foundation
import SwiftUI

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
            return AnyView(TextInputCardView(placeholder: self.prompt))
        case "LongString":
            return AnyView(TextInputCardView(numLines: 3, placeholder: self.prompt))
        case "Int":
            return AnyView(EmptyView())
        case "Date":
            return AnyView(EmptyView())
        case "Multichoice":
            return AnyView(EmptyView())
        default:
            return AnyView(EmptyView())
        }

    }
    
}

struct TextInputCardView : View{
    
    @State var numLines = 1
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
    }
}

struct TextInputCardView_Preview : PreviewProvider{
    static var previews : some View{
        ZStack{
            Color.mid
            TextInputCardView(placeholder: "Enter the service you'd like to add")
        }
    }
}
