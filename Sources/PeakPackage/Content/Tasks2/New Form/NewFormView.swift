//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/31/21.
//

import Foundation
import SwiftUI

struct NewFormView : View {
    
    @Binding var allforms : [AutoForm]
    @Binding var showing : Bool
    @State var elements : [NewFormElement] = []
    @State var finalElements : [AutoFormElement] = []
    @State var isEditable = false
    @State var title = ""
    @State var subtitle = ""
    let pickerOpt = ["Complimentary","User Requested"]
    @State var picked = 0
    let semaphore = DispatchSemaphore(value: 1)
    var loadedAllInputs : Bool {
        return finalElements.count == elements.count
    }
    
    var body : some View {
        NavigationView{
            List{
                
                TextField("Title", text: $title)
                    .padding(20)
                    .background(Color.lightAccent)
                    .cornerRadius(20)
                
                TextField("Subtitle", text: $subtitle)
                    .padding(20)
                    .background(Color.lightAccent)
                    .cornerRadius(20)
                
                Picker(
                    selection: $picked,
                    label: Text(""),
                    content: {
                    //display each of the duration choices
                    ForEach(0 ..< pickerOpt.count){
                        i in
                        Text(self.pickerOpt[i])
                    }
                })
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(height: 50)
                    .padding(.horizontal, 30)
                
                ForEach(elements, id: \.id){
                    el in
                    el
                }
                .onMove(perform: move)
                
                HStack{
                    Spacer()
                    Button(action: {
                        isEditable.toggle()
                    }, label: {
                        Image(systemName: isEditable ? "pencil.slash" : "pencil")
                            .foregroundColor(Color.darkAccent.opacity(isEditable ? 0.5 : 1.0))
                            .imageScale(.large)
                    })
                    .TrailingButton()
                    .padding(20)
                    
                    Button(action: {
                        elements.append(NewFormElement(isEditable: $isEditable))
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.darkAccent)
                    })
                    .RoundRectButton_NotCentered()
                    
                    Button(action: {
                        gatherInformation()
                    }, label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.darkAccent)
                    })
                    .TrailingButton()
                    .padding(20)
                    Spacer()
                }
            }
            .CleanList()
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
//            .environment(\.editMode, .constant(.active))
            .navigationTitle("New Form")
        }
        .stackOnlyNavigationView()
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ElementValue")), perform: { obj in
            DispatchQueue.global().async {
                semaphore.wait()
                let data = obj.userInfo as! [String : Any]
                if let _ = data["id"] as? UUID,
                         let input = data["input"] as? AutoFormElement,
                         let _ = data["key"] as? String{
                    finalElements.append(input)
                    if loadedAllInputs {
                        let form = AutoForm(
                            visibility: picked == 0 ? "admin" : nil,
                            title: title,
                            subtitle: subtitle,
                            elements: finalElements)
                        submit(form: form)
                    }
                }
                semaphore.signal()
            }
        })
    }
    
    func move(from source: IndexSet, to destination: Int) {
            elements.move(fromOffsets: source, toOffset: destination)
//            withAnimation {
//                isEditable = false
//            }
        }
    
    func submit(form: AutoForm) {
        DatabaseDelegate.submitNewFormType(form: form, completion: {
            _ in
            allforms.append(form)
            showing = false
        })
    }
    
    func gatherInformation(){
        if elements.count == 0 {
            let form = AutoForm(
                visibility: picked == 0 ? "admin" : nil,
                title: title,
                subtitle: subtitle,
                elements: [])
            submit(form: form)
        }else{
            for el in elements {
                NotificationCenter.default.post(name: Notification.Name("FormSubmit"), object: nil, userInfo: ["id": el.id])
            }
        }
    }
}

struct NewFormElement : View {
    
    let id = UUID()
    @Binding var isEditable : Bool
    @State var title = ""
    @State var subtitle = ""
    @State var input = 0
    let elementOptions = [
        AutoFormInputType.ShortString,
        AutoFormInputType.LongString,
        AutoFormInputType.Int,
        AutoFormInputType.Date,
        AutoFormInputType.Image,
        AutoFormInputType.Multichoice(options: [])]
    let positionOfMultichoice = 5
    @State var optionsForMultiview : [String] = []
    
    var body : some View {
        VStack{
            Text("Type:")
                .CardTitle()
            Text(elementOptions[input].string())
                .Caption()
            Picker(
                selection: $input,
                label: Text(""),
                content: {
                //display each of the duration choices
                ForEach(0 ..< elementOptions.count){
                    i in
                    Image(systemName: self.elementOptions[i].imageName())
                }
            })
                .pickerStyle(SegmentedPickerStyle())
                .frame(height: 50)
                .padding(.horizontal, 30)
            
            TextField("title of field", text: $title)
                .padding(20)
                .cornerRadius(20)
            
            TextField("prompt of field", text: $subtitle)
                .padding(20)
                .cornerRadius(20)
            
            if input == positionOfMultichoice {
                AddOptionsToMultiView(options: $optionsForMultiview)
            }
        }
        .BasicContentCard()
        .onReceive(formPub, perform: { obj in
            if let info = obj.userInfo{
                if let collectedId = info["id"] as? UUID {
                    if collectedId == id {
                        NotificationCenter.default.post(
                            name: Notification.Name("ElementValue"),
                            object: nil,
                            userInfo: ["input" :  asAutoFormElement(), "id" : id, "key" : title])
                    }
                }
            }
        })
    }
    
    func asAutoFormElement() -> AutoFormElement{
        if input == positionOfMultichoice{
            
            return AutoFormElement(
                label: title,
                prompt: subtitle,
                input: AutoFormInputType.Multichoice(options: optionsForMultiview))
        }else{
           
            return AutoFormElement(
                label: title,
                prompt: subtitle,
                input: elementOptions[input])
        }
    }
}

struct AddOptionsToMultiView : View{
    
    @Binding var options : [String]
    @State var addingNewOption = false
    @State var newOptionText = ""
    
    var body : some View {
        VStack{
            List{
                ForEach(options, id: \.self){
                    opt in
                    Text(opt)
                        .Caption()
                }
            }
            .CleanList(rowH: 30)
            .listRowBackground(Color.darkAccent.opacity(0.1))
            
            HStack{
                TextField("New Option", text: $newOptionText)
                    .padding(20)
                    .cornerRadius(20)
                Button(action: {
                        options.append(newOptionText)
                        newOptionText = ""
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.darkAccent)
                        .imageScale(.large)
                })
                .TrailingButton()
            }
        }
        .frame(height: 200)
    }
}
