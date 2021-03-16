//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/16/21.
//

import Foundation
import SwiftUI

struct markupElement : View{
    
    let id = UUID()
    @State var type : markupType
    @State var text : String
    
    var body : some View{
        type.getView(text: text)
    }
}

enum markupType{
    
    case title
    case body
    
    func getView(text: String) -> some View{
        
        switch self {
        case .title:
            return AnyView(Text(text).markupTitle())
        default:
            return AnyView(Text(text).markupBody())
        }
        
        return AnyView(EmptyView())
        
    }
    
    static func regex() -> String{
        var regex = ""
        
       // regex = "\(self.openTag())[^<]\(self.closeTag())"
        
        regex = "<[^>]>"
        
        return regex
    }
    
    func openTag() -> String{
        var tag = ""
        
        switch self {
        case .title:
            tag = "<title>"
        default:
            tag = "<body>"
        }
        
        return tag
    }
    
    func closeTag() -> String{
        var tag = ""
        
        switch self {
        case .title:
            tag = "</title>"
        default:
            tag = "</body>"
        }
        
        return tag
    }

}

struct MarkUpView : View {
    
    @State var text : String
    @State var elements : [markupElement] = []
    
    var body: some View{
        ForEach(elements, id: \.id){ markup in
            markup
        }.onAppear{
            parseElements()
        }
    }
    
    func parseElements(){
        do{
            let regex = "<[^>]>"
            let detector = try NSDataDetector(pattern: regex)
            let matches = detector.matches(in: text ,range: NSRange(text.startIndex..., in: text))
            for match in matches{
                    let start = text.index(text.startIndex, offsetBy: match.range.lowerBound)
                    let end = text.index(text.startIndex, offsetBy: match.range.upperBound)
                    let range = start ..< end
                    let detail = text[range]
                let element = markupElement(type: .title, text: String(detail))
            }
        }catch{
            
        }
    }
}

extension Text {
    func markupTitle() -> some View{
        return self
            .bold()
            .font(.headline)
            .markupElement()
    }
    
    func markupBody() -> some View{
        return self
            .font(.body)
            .markupElement()
    }
    
    func markupElement() -> some View{
        return self
            .padding(.bottom, 10)
    }
}
