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
                    Button(action: {
                        isEditable.toggle()
                    }, label: {
                        Image(systemName: isEditable ? "pencil.slash" : "pencil")
                            .foregroundColor(Color.darkAccent.opacity(isEditable ? 0.5 : 1.0))
                    })
                    .padding(20)
                    
                    Button(action: {
                        elements.append(NewFormElement(isEditable: $isEditable))
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.darkAccent)
                    })
                    .RoundRectButton()
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
    @State var input = 0
    let elementOptions = [
        AutoFormInputType.ShortString,
        AutoFormInputType.LongString,
        AutoFormInputType.Int,
        AutoFormInputType.Date,
        AutoFormInputType.Image,
        AutoFormInputType.Multichoice(options: [])]
    
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
            
//            HStack{
//                Spacer()
//                Image(systemName: "ellipsis.circle.fill")
//                    .onTapGesture {
//                        withAnimation {
//                            isEditable = true
//                        }
//                    }
//            }
        }
        .BasicContentCard()
    }
}
