//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/24/21.
//

import SwiftUI

struct AutoFormView: View {
    
    var form : AutoForm
    @State var elementIDs : [UUID] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    Text(form.subtitle)
                        .Caption()
                        .fullWidth()
                    ForEach(form.elements, id: \.id){
                        element in
                        Text(element.label)
                            .CardTitle()
                            .fullWidth()
                        element.inputView()
                    }
                    
                    //allows margin for button
                    ForEach(0..<6, content: { _ in 
                        EmptyView()
                    })
                
                }
                .FormList()
                .navigationBarTitle(Text(form.title), displayMode: .inline)
                
                VStack{
                    Spacer()
                    Button(action: {
                        #warning("TODO submit task")
                    }, label: {
                        HStack{
                            Image(systemName: "paperplane.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color.darkAccent)
                            Text("Submit")
                                .CardTitle()
                        }
                    })
                    .RoundRectButton()
                    .padding(.bottom, 20)
                }
            }
        }
        .stackOnlyNavigationView()
    }
}

struct AutoFormView_Previews: PreviewProvider {
    static var previews: some View {
        AutoFormView(form: AutoForm(
                        title: "Service Page Addition",
                        subtitle: "A Service page will be added to your website",
                        elements: [
                            AutoFormElement(label: "Service", prompt: "Enter the service you'd like to add", input: "ShortString"),
                            AutoFormElement(label: "Custom Content", prompt: "Enter any custom content", input: "LongString")
                        ]))
    }
}
