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

    var vis : String
    var title : String
    var subtitle : String
    var elements : [AutoFormElement]
    
}

extension AutoForm {
    
    init(visibility: String?, title: String, subtitle: String, elements: [AutoFormElement]){
        var tempVis = ""
        if visibility == nil {
            if defaults.getApplicationType() == .NHanceConnect {
                tempVis = "nhance"
            }else{
                tempVis = "peak"
            }
        }else{
            tempVis = visibility!
        }
        self = AutoForm(vis: tempVis, title: title, subtitle: subtitle, elements: elements)
    }
    
    func visibleForm() -> visibleAutoForm{
        return visibleAutoForm(form: self)
    }
}

struct visibleAutoForm : Identifiable {
    
    var id = UUID()
    var vis : String
    var title : String
    var subtitle : String
    var elements : [visibleAutoFormElement]
    
    init(form: AutoForm){
        vis = form.vis
        title = form.title
        subtitle = form.subtitle
        elements = form.elements.map({$0.visibleElement()})
    }
}

extension visibleAutoForm {
    
    init(visibility : String? = nil, title : String, subtitle : String, elements : [AutoFormElement]) {
        if visibility == nil {
            if defaults.getApplicationType() == .PeakClients(.any){
                self.vis = "peak"
            }else{
                self.vis = "nhance"
            }
        }else{
            self.vis = visibility!
        }
        self.title = title
        self.subtitle = subtitle
        self.elements = elements.map({$0.visibleElement()})
        self.id = UUID()
    }
}

struct AutoFormElement : Codable {
    
    var label : String
    var prompt : String
    var input : String
    
}

extension AutoFormElement {
    
    init(label: String, prompt: String, input: AutoFormInputType){
        self = AutoFormElement(label: label, prompt: prompt, input: input.string())
    }
    
    func visibleElement() -> visibleAutoFormElement{
        return visibleAutoFormElement(element: self)
    }
    
}

struct visibleAutoFormElement {
    
    var id = UUID()
    var label : String
    var prompt : String
    var input : String
    
    init(element : AutoFormElement){
        label = element.label
        prompt = element.prompt
        input = element.input
    }
    
    func inputView() -> AnyView {
        let type = AutoFormInputType(type: self.input)
        return type.view(id: id, label: self.label, prompt: self.prompt)
    }
}

struct ImageInputCardView : View {
    
    var id : UUID
    @State var title : String
    @State var prompt : String
    @State var input : [UIImage] = []
    @State var showingPhotoLibrary = false
    @State var selectedImage : UIImage = UIImage()
    
    var body : some View{
        HStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(input, id: \.self){
                        image in
                        VStack{
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 70, height: 70)
                        EmptyView().frame(width: 10)
                    }
                    
                    Button(action: {
                        showingPhotoLibrary = true
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(Color.darkAccent)
                    }
                    .frame(width: 70, height: 70)
                    .background(Color.darkAccent.opacity(0.1))
                }
            }
        }
        .BasicContentCard()
        .sheet(isPresented: $showingPhotoLibrary) {
            ImagePicker(
                selectedImage: self.$selectedImage,
                onComplete: {
                    input.append(self.selectedImage)
                },
                sourceType: .photoLibrary)
        }
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

struct MultiInputCardView : View {
    
    var id : UUID
    @State var title : String
    @State var prompt : String
    @State var input = 0
    @State var choices : [String]
    
    var body : some View{
        VStack{
            Text(prompt)
                .Caption()
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
    
    static func makeChoiceList(text: String) -> [String]{
        var start = text.firstIndex(of: "(") ?? text.startIndex
        start = text.index(after: start)
        var end = text.lastIndex(of: ")") ?? text.endIndex
        var listString = String(text[start..<end])
        var list = listString.components(separatedBy: ",")
        return list
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
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: input)
    }
}

struct TimeInputCardView : View {
    
    var id : UUID
    @State var title : String
    @State var prompt : String
    @State var selectedDay : Date = Date()
    @State var inputStart : Date? = nil
    @State var inputEnd : Date? = nil
    @State var timeText = "Pick Time"
    @State var showWarning = false
    @State var pickingTime = false
    
    var body : some View {
        HStack{
            Button(action: {
                pickingTime = true
            }, label: {
                Text(timeText)
            })
            .defaultDateSelectButton()
            DatePicker("", selection: $selectedDay, displayedComponents: .date)
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
        .sheet(isPresented: $pickingTime, content: {
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    Text("Choose a Time:")
                        .CardTitle()
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.lightAccent)
                Divider().foregroundColor(Color.darkAccent)
                AppointmentSelectionView(inputStartTime: $inputStart, inputEndTime: $inputEnd, text: $timeText)
            }
        })
    }
    
    func parseInputDate() -> (String,String,String)? {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm:ss"
        if inputStart == nil || inputEnd == nil {
            return nil
        }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return (timeformatter.string(from: inputStart!),
                timeformatter.string(from: inputEnd!),
                dateformatter.string(from: selectedDay))
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

