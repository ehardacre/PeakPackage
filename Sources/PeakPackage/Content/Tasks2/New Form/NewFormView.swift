//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 3/31/21.
//

import Foundation
import SwiftUI

struct NewFormView : View {
    
    @State var elements : [NewFormElement] = []
    @State var isEditable = false
    
    var body : some View {
        NavigationView{
            List{
                AutoFormElement(
                    label: "Title",
                    prompt: "Title for Form",
                    input: "ShortString")
                    .inputView()
                
                AutoFormElement(
                    label: "Subtitle",
                    prompt: "Subtitle for Form",
                    input: "ShortString")
                    .inputView()
                
                AutoFormElement(
                    label: "Form Type",
                    prompt: "",
                    input: "Multichoice(Complimentary,User Requested)")
                    .inputView()
                
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
                    Spacer()
                    
                    Button(action: {
                        #warning("TODO: submit form")
                    }, label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.darkAccent)
                    })
                    .TrailingButton()
                    Spacer()
                }
            }
            .CleanList()
            .environment(\.editMode, isEditable ? .constant(.active) : .constant(.inactive))
//            .environment(\.editMode, .constant(.active))
            .navigationTitle("New Form")
        }
        .stackOnlyNavigationView()
    }
    
    func move(from source: IndexSet, to destination: Int) {
            elements.move(fromOffsets: source, toOffset: destination)
//            withAnimation {
//                isEditable = false
//            }
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
            
            TextField("subtitle of field", text: $subtitle)
                .padding(20)
                .cornerRadius(20)
            
            if input == positionOfMultichoice {
                AddOptionsToMultiView(options: $optionsForMultiview)
            }
        }
        .BasicContentCard()
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
