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
                
                Button(action: {
                    elements.append(NewFormElement())
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.darkAccent)
                })
                .RoundRectButton()
            }
            .navigationTitle("New Form")
        }
        .stackOnlyNavigationView()
    }
}

struct NewFormElement : View {
    
    let id = UUID()
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
                .frame(height: 100)
                .padding(.horizontal, 30)
        }
        .BasicContentCard()
    }
}
