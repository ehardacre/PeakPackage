//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/15/21.
//

import Foundation
import SwiftUI

enum markUpTags : String{
    case newLine = "\n"
    case title = "<title>"
    case end_title = "</title>"
    case body = "<body>"
    case end_body = "</body>"
}

struct MarkUpText : View {
    
    @State var text : String
    
    var body : some View{
        
    }
    
    func parseText() -> some View{
        
    }
}

struct MarkUpText_Preview : PreviewProvider {
    
    static var previews : some View{
        MarkUpText(text: "")
    }
    
}


