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
    @State var taskManager : TaskManager2
    var form : visibleAutoForm
    @State var appointmentForm = false
    @State var elementIDs : [UUID] = []
    @State var loadedElementInputs : [UUID] = []
    @State var inputList : [String:String] = [:]
    @State var submittingTask = false
    @State var choosingFranchise = false
    @State var descriptionText = "Completing Form..."
    let semaphore = DispatchSemaphore(value: 1)
    @ObservedObject var franchiseManager = FranchiseSelectionManager()
    @State var profilesLoaded = false
    @State var dismissFunction :  () -> Void = {return}
    @State var imagesToSubmit : [UIImage] = []
    let imageSendSemaphore = DispatchSemaphore(value: 1)
    @State var showingError = false
    @State var errorMessage = ""
    
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
                        element.inputView(taskManager: taskManager)
                            .buttonStyle(PlainButtonStyle())
                    }
                    if defaults.admin && profilesLoaded{
                        FranchiseSelectionView(profiles: franchiseManager.profiles, profileManager: franchiseManager)
                            .frame(height: 300)
                            .cornerRadius(20)
                    }
                    if showingError {
                        Text(errorMessage)
                            .ErrorText()
                    }
                    Button(action: {
                        //collect data from views
                        showingError = false
                        errorMessage = ""
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
                
                //detect error from fields
                if data["error"] != nil {
                    var tempError = (data["error"] as? String)
                    if tempError == nil {
                        showingError = false
                    }else{
                        showingError = true
                        errorMessage = (data["error"] as? String) ?? "Unknown Error"
                    }
                }
                
                //detect error from franchise selection
                if appointmentForm && franchiseManager.ids.count > 1 {
                    showingError = true
                    errorMessage = "Only one Franchise can be selected for an Appointment."
                }
                
                if let id = data["id"] as? UUID,
                   let input = data["input"] as? [UIImage],
                   let key = data["key"] as? String{
                    loadedElementInputs.append(id)
                    inputList[key] = "\(input.count) images submitted"
                    if inputEqualsFields() && !showingError{
                        descriptionText = "Submitting Task..."
                        printr("all fields collected")
                        printr(inputList)
                        if appointmentForm {
                            sendInAppointment(inputs: inputList)
                        }else{
                            sendInTask(inputs: inputList)
                        }
                    }else if showingError {
                        submittingTask = false
                    }
                }else if let id = data["id"] as? UUID,
                         let input = data["input"] as? (String, String, String),
                         let key = data ["key"] as? String{
                    
                    loadedElementInputs.append(id)
                    inputList["time"] = "\(input.0)*\(input.1)*\(input.2)"
                    if inputEqualsFields() && !showingError{
                        descriptionText = "Submitting Task..."
                        printr("all fields collected")
                        printr(inputList)
                        if appointmentForm {
                            sendInAppointment(inputs: inputList)
                        }else{
                            sendInTask(inputs: inputList)
                        }
                    }else if showingError {
                        submittingTask = false
                    }
                }else if let id = data["id"] as? UUID,
                   let input = data["input"] as? Any,
                   let key = data["key"] as? String{
                    loadedElementInputs.append(id)
                    inputList[key] = input as? String
                    if inputEqualsFields() && !showingError{
                        descriptionText = "Submitting Task..."
                        printr("all fields collected")
                        printr(inputList)
                        if appointmentForm {
                            sendInAppointment(inputs: inputList)
                        }else{
                            sendInTask(inputs: inputList)
                        }
                    }else if showingError {
                        submittingTask = false
                    }
                }
                semaphore.signal()
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("FranchiseListLoaded")), perform: { note in
            profilesLoaded = true
        })
    }
    
    func sendInAppointment(inputs: [String:String]){
        var timeInputs = inputs["time"]?.components(separatedBy: "*") ?? []
        if timeInputs.count == 3 {
            var startTime = timeInputs[0]
            var endTime = timeInputs[1]
            var dateTime = timeInputs[2]
            var description = inputs["Subject"] ?? ""
            var id = franchiseManager.ids.first
            DatabaseDelegate.setAppointment(franchiseId: id, startTime: startTime, endTime: endTime, date: dateTime, description: description, completion: {
                rex in
                taskManager.reloadAppointmentData()
                presentationMode.wrappedValue.dismiss()
            })
        }
        
    }
    
    func sendInTask(inputs: [String:String]){
        if showingError {
            return
        }
        //format inputs into string
        var taskString = "[\(form.title):\(defaults.franchiseName() ?? "")]"
        for key in inputs.keys {
            taskString += "[\(key):\(inputs[key] ?? "")]"
        }
        
        DatabaseDelegate.sendTask(ids: franchiseManager.ids, taskInfo: taskString, completion: {
            rex in
            
            imageSendSemaphore.wait()
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
            imageSendSemaphore.signal()
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

//struct AutoFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        AutoFormView(
//                     form: AutoForm(
//                        vis: "admin", title: "Service Page Addition",
//                        subtitle: "A Service page will be added to your website",
//                        elements: [
//                            AutoFormElement(label: "Service", prompt: "Enter the service you'd like to add", input: "ShortString"),
//                            AutoFormElement(label: "Custom Content", prompt: "Enter any custom content", input: "LongString")
//                        ]).visibleForm())
//    }
//}
