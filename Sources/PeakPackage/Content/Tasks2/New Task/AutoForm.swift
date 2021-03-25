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
            return AnyView(TextInputCardView(
                            id: self.id,
                            title: self.label,
                            placeholder: self.prompt,
                            integer: true))
        case "Date":
            return AnyView(DateInputCardView(
                            id: self.id,
                            title: self.label,
                            prompt: self.prompt))
        case let str where str.contains("Multichoice"):
            return AnyView(MultiInputCardView(
                            id: self.id,
                            title: self.label,
                            prompt: self.prompt,
                            multiInputText: self.input))
        case "Image":
            return AnyView(EmptyView())
        default:
            return AnyView(EmptyView())
        }

    }
    
}

struct MultiInputCardView : View {
    
    var id : UUID
    @State var title : String
    @State var prompt : String
    @State var multiInputText : String
    @State var input = 0
    @State var choices : [String] = []
    
    var body : some View{
        HStack{
            Picker(
                selection: $input,
                label: Text(""),
                content: {
                //display each of the duration choices
                ForEach(0 ..< choices.count){
                    i in
                    Text(self.choices[i])
                }
            })
                .pickerStyle(SegmentedPickerStyle())
                .frame(height: 50)
                .padding(.horizontal, 30)
        }
        .BasicContentCard()
        .onAppear{
            makeChoiceList()
        }
        .onReceive(formPub, perform: { obj in
            if let info = obj.userInfo{
                if let collectedId = info["id"] as? UUID {
                    if collectedId == id {
                        NotificationCenter.default.post(
                            name: Notification.Name("ElementValue"),
                            object: nil,
                            userInfo: ["input" :  choices[input], "id" : id, "key" : title])
                    }
                }
            }
        })
    }
    
    func makeChoiceList(){
        var start = multiInputText.firstIndex(of: "(") ?? multiInputText.startIndex
        var end = multiInputText.lastIndex(of: ")") ?? multiInputText.endIndex
        var listString = String(multiInputText[start..<end])
        var list = listString.components(separatedBy: ",")
        choices = list
    }

}

struct DateInputCardView : View {
    
    var id : UUID
    @State var title : String
    @State var prompt : String
    @State var input : Date = Date()
    
    var body : some View {
        HStack{
            Text(prompt)
                .Caption()
            DatePicker("", selection: $input, displayedComponents: .date)
        }
        .BasicContentCard()
        .onReceive(formPub, perform: { obj in
            if let info = obj.userInfo{
                if let collectedId = info["id"] as? UUID {
                    if collectedId == id {
                        NotificationCenter.default.post(
                            name: Notification.Name("ElementValue"),
                            object: nil,
                            userInfo: ["input" :  parseInputDate(), "id" : id, "key" : title])
                    }
                }
            }
        })
    }
    
    func parseInputDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yMd"
        return formatter.string(from: input)
    }
}

//MARK: TextInputCard

struct TextInputCardView : View{
    
    var id : UUID
    @State var numLines = 1
    @State var title : String
    @State var placeholder : String
    @State var input = ""
    @State var integer = false
    
    var body : some View {
        ZStack{
            TextEditor(text: $input)
                .cornerRadius(20)
                .multilineTextAlignment(numLines == 1 ? .center : .leading)
                .onTapGesture {
                    self.placeholder = ""
                }
                .if(
                    integer,
                    content: {
                        $0.keyboardType(.numberPad)
                    })
            Text(placeholder)
                .Caption()
        }
        .frame(height: CGFloat(numLines) * 50)
        .BasicContentCard()
        .onReceive(formPub, perform: { obj in
            if let info = obj.userInfo{
                if let collectedId = info["id"] as? UUID {
                    if collectedId == id {
                        NotificationCenter.default.post(
                            name: Notification.Name("ElementValue"),
                            object: nil,
                            userInfo: ["input" :  input, "id" : id, "key" : title])
                    }
                }
            }
        })
    }
}

struct TextInputCardView_Preview : PreviewProvider{
    static var previews : some View{
        ZStack{
            Color.mid
            TextInputCardView(
                id: UUID(),
                title: "key",
                placeholder: "Enter the service you'd like to add")
        }
    }
}

