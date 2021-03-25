//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/24/21.
//

import SwiftUI
import Introspect

struct AutoFormView: View {
    
    @Binding var showing : Bool
    var form : AutoForm
    @State var elementIDs : [UUID] = []
    @State var loadedElementInputs : [UUID] = []
    @State var submittingTask = false
    @State var descriptionText = "Completing Form..."
    
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
                            .onAppear{
                                elementIDs.append(element.id)
                            }
                        element.inputView()
                    }
                    Button(action: {
                        //collect data from views
                        submittingTask = true
                        descriptionText = "Collecting Response..."
                        NotificationCenter.default.post(name: Notification.Name("FormSubmit"), object: nil)
                        
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
                .FormList()
                .navigationBarTitle(Text(form.title), displayMode: .inline)
                .navigationBarItems(leading:
                                        Button(action: {
                                            showing = false
                                        }, label: {
                                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                                .foregroundColor(.darkAccent)
                                                .imageScale(.large)
                                        })
                )
            
                if submittingTask {
                    HStack{
                        ProgressView()
                        Text(descriptionText)
                            .Caption()
                    }
                    .frame(minWidth: 250)
                    .background(Color.lightAccent)
                    .cornerRadius(20)
                }
            }
        }
        .stackOnlyNavigationView()
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ElementValue")), perform: { obj in
            var data = obj.userInfo as! [String : Any]
            if let id = data["id"] as? UUID,
               let input = data["input"] as? Any,
               let key = data["key"] as? String{
                loadedElementInputs.append(id)
                if inputEqualsFields(){
                    descriptionText = "Submitting Task..."
                }
            }
        })
    }
    
    func inputEqualsFields() -> Bool{
        if loadedElementInputs.count != elementIDs.count{
            return false
        }
        for id in elementIDs {
            if !loadedElementInputs.contains(id){
                return false
            }
        }
        return true
    }
}

struct AutoFormView_Previews: PreviewProvider {
    static var previews: some View {
        AutoFormView(showing: .constant(true),
                     form: AutoForm(
                        title: "Service Page Addition",
                        subtitle: "A Service page will be added to your website",
                        elements: [
                            AutoFormElement(label: "Service", prompt: "Enter the service you'd like to add", input: "ShortString"),
                            AutoFormElement(label: "Custom Content", prompt: "Enter any custom content", input: "LongString")
                        ]))
    }
}
