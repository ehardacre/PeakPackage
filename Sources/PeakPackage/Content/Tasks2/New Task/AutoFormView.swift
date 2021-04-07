//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/24/21.
//

import SwiftUI
import Introspect

struct AutoFormView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    var form : visibleAutoForm
    @State var elementIDs : [UUID] = []
    @State var loadedElementInputs : [UUID] = []
    @State var inputList : [String:String] = [:]
    @State var submittingTask = false
    @State var choosingFranchise = false
    @State var descriptionText = "Completing Form..."
    let semaphore = DispatchSemaphore(value: 1)
    @ObservedObject var franchiseManager = FranchiseSelectionManager()
    @State var dismissFunction :  () -> Void = {return}
    @State var imagesToSubmit : [UIImage] = []
    
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
                    if defaults.admin{
                        FranchiseSelectionView(profiles: franchiseManager.profiles, profileManager: franchiseManager)
                            .frame(height: 300)
                            .cornerRadius(20)
                            .onAppear{
                                #warning("TODO: add profiles for peak studios app")
                                franchiseManager.loadProfiles()
                            }
                    }
                    Button(action: {
                        //collect data from views
                        loadedElementInputs.removeAll()
                        submittingTask = true
                        if defaults.admin {
                            choosingFranchise = true
                        }
                        descriptionText = "Collecting Response..."
                        for id in elementIDs {
                            NotificationCenter.default.post(name: Notification.Name("FormSubmit"), object: nil, userInfo: ["id": id])
                        }
                        
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
                                            dismissFunction()
                                        }, label: {
                                            Image(systemName: "chevron.backward")
                                                .foregroundColor(.darkAccent)
                                                .imageScale(.large)
                                        })
                )
            
                if submittingTask {
                    VStack{
                        ProgressView()
                            .padding(.bottom, 20)
                        Text(descriptionText)
                            .Caption()
                    }
                    .padding(20)
                    .frame(minWidth: 250)
                    .background(Color.lightAccent)
                    .cornerRadius(20)
                }
            }
        }
        .stackOnlyNavigationView()
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ElementValue")), perform: { obj in
            
            DispatchQueue.global().async {
                semaphore.wait()
                var data = obj.userInfo as! [String : Any]
                
                if let id = data["id"] as? UUID,
                   let input = data["input"] as? [UIImage],
                   let key = data["key"] as? String{
                    loadedElementInputs.append(id)
                    inputList[key] = "\(input.count) images submitted"
                    if inputEqualsFields(){
                        descriptionText = "Submitting Task..."
                        printr("all fields collected")
                        printr(inputList)
                        sendInTask(inputs: inputList)
                    }
                }else if let id = data["id"] as? UUID,
                   let input = data["input"] as? Any,
                   let key = data["key"] as? String{
                    loadedElementInputs.append(id)
                    inputList[key] = input as! String
                    if inputEqualsFields(){
                        descriptionText = "Submitting Task..."
                        printr("all fields collected")
                        printr(inputList)
                        sendInTask(inputs: inputList)
                    }
                }
                semaphore.signal()
            }
        })
    }
    
    func sendInTask(inputs: [String:String]){
        //format inputs into string
        var taskString = ""
        for key in inputs.keys {
            taskString += "[\(key):\(inputs[key])]"
        }
        
        DatabaseDelegate.sendTask(taskInfo: taskString, completion: {
            rex in
            let id = rex as! String
            if imagesToSubmit.count > 0 {
                DatabaseDelegate.sendImages(images: imagesToSubmit, taskId: id, completion: {
                    _ in
                    submittingTask = false
                    presentationMode.wrappedValue.dismiss()
                })
            }else{
                submittingTask = false
                presentationMode.wrappedValue.dismiss()
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
        AutoFormView(
                     form: AutoForm(
                        vis: "admin", title: "Service Page Addition",
                        subtitle: "A Service page will be added to your website",
                        elements: [
                            AutoFormElement(label: "Service", prompt: "Enter the service you'd like to add", input: "ShortString"),
                            AutoFormElement(label: "Custom Content", prompt: "Enter any custom content", input: "LongString")
                        ]).visibleForm())
    }
}
