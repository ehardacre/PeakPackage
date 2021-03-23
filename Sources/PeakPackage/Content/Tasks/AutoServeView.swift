//
//  AutoServeView.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 9/25/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import SwiftUI

struct AutoServeType_hash : Identifiable{
    var id = UUID()
    var type : AutoServeType
}

struct AutoServeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var selection = 3
    @State var formLayout = [AutoServeType_hash(type: .title("Loading...",subtitle: "Internet Connection Required."))]
    
    var title : String
    var formId : String
    var franchise : String
    
    //format is : [ ID : (key, value) ]
    @State var textInputs = [UUID: String]()
    @State var multiChoiceInputs = [UUID: Int]()
    @State var multiChoiceOptions = [UUID: [String]]()
    @State var dateInputs = [UUID: Date]()
    @State var incrementInputs = [UUID: Int]()
    @State var formTitles = [UUID: String]()
    @State private var isShowPhotoLibrary = false
    @State private var isSelectedImage = false
    @State private var image = UIImage()
    
    init(title: String, formId: String, franchise: String) {
        self.title = title
        self.franchise = franchise
        self.formId = formId
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(formLayout, id: \.id) {
                    layout_element in
                    HStack{
                        Spacer()
                        self.switchView(
                            served: layout_element.type,
                            index: layout_element.id)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(SidebarListStyle())
            .background(Color.b_or_w.ignoresSafeArea(edges: .all))
            .onAppear{
                self.getFormLayout()
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(
                selectedImage: self.$image,
                onComplete: {
                    self.isSelectedImage = true
                },
                sourceType: .photoLibrary)
        }
    }
    
    func getFormLayout() {
        let json = JsonFormat.getDynamicForm(id: formId).format()
        DatabaseDelegate.performRequest(
            with: json,
            ret: returnType.form,
            completion: {
                rex in
                self.formLayout = (rex as! [Form_Element]).map({
                    $0.convertToHashable()
                })
                self.formLayout.append(AutoServeType_hash(type: .submitButton))
        })
    }
    
    func switchView(served: AutoServeType, index: UUID) -> AnyView {
        switch served{
        case .textInput(let placeHolder):
            return AnyView(
                VStack{
                    Text(placeHolder)
                        .font(.footnote)
                        .foregroundColor(.main)
                    TextField(
                        "",
                        text: self.$textInputs[index]
                            .unwrap(def: .constant("failed"))!
                    )
                    .onAppear{
                        self.textInputs[index] = ""
                        self.formTitles[index] = placeHolder
                    }
                    .multilineTextAlignment(.center)
                        Divider()
                            .frame(width: 200)
                }
                .padding(30)
                .background(Color.lightAccent)
                .cornerRadius(20)
            )
        case .title(let title, let subtitle):
            return AnyView(
                VStack{
                    Text(title)
                        .bold()
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(Color.main)
                }
                .padding(30)
            )
        case .datePicker(let start, let end):
            return AnyView(
                //the date picker for the appointment
                VStack{
                    DatePicker(
                        "",
                        selection: $dateInputs[index]
                            .unwrap(def: .constant(Date()))!,
                        in: start...end,
                        displayedComponents: .date)
                        .onAppear{
                            self.dateInputs[index] = start
                            self.formTitles[index] = "Date"
                        }
                }
                .padding(30)
                .background(Color.lightAccent)
                .cornerRadius(20)
            )
        case .incrementPicker(let min, let max, let interval, let units):
            return AnyView(
                Text("This form element is not ready")
            )
        case .datetimePicker(let start, let end):
            return AnyView(
                //the date picker for the appointment
                VStack{
                DatePicker(
                    "",
                    selection: $dateInputs[index]
                        .unwrap(def: .constant(Date()))!,
                    in: start...end)
                    .onAppear{
                        self.dateInputs[index] = start
                        self.formTitles[index] = "Time"
                    }
                }
                .padding(30)
                .background(Color.lightAccent)
                .cornerRadius(20)
            )
        case .imagePicker:
            return AnyView(
                    VStack{
                        if self.isSelectedImage {
                            Image(uiImage: self.image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .onTapGesture {
                                    self.isShowPhotoLibrary = true
                                }
                        }else{
                            Button(action: {
                                self.isShowPhotoLibrary = true
                            }){
                                Text("Choose an Image")
                                .foregroundColor(Color.darkAccent)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.darkAccent)
                                )
                            }
                        }
                    }
                    .padding(30)
                    .background(Color.lightAccent)
                    .cornerRadius(20)
            )
        case .multichoice(let choices):
            return AnyView(
                //appointment time pickers
                Picker(
                    selection: $multiChoiceInputs[index]
                        .unwrap(def: .constant(0))!,
                    label: Text(""),
                    content: {
                        //display each of the duration choices
                        ForEach(0 ..< choices.count){ i in
                            Text(choices[i])
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(height: 30)
                    .padding(.horizontal, 30)
                    .onAppear{
                        self.multiChoiceInputs[index] = 0
                        self.multiChoiceOptions[index] = choices
                        self.formTitles[index] = "Option"
                    }
                    .padding(30)
            )
        default:
            return AnyView(
                 Button(
                    action: {
                        self.submitForm()
                    },
                    label: {
                       Text("Submit")
                            .foregroundColor(Color.darkAccent)
                            .frame(width: 100)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.darkAccent)
                            )
                    })
            )
        }
    }
    
    func submitForm(){
        let taskTitle = "(\(title) for \(franchise)) "
        var taskBody = "Details include "
        for t in textInputs {
            taskBody.append("[\(self.formTitles[t.key]!): \(t.value)] ")
        }
        for t in multiChoiceInputs {
            taskBody.append("[\(self.formTitles[t.key]!): \(multiChoiceOptions[t.key]?[t.value])] ")
        }
        for t in dateInputs {
            taskBody.append("[\(self.formTitles[t.key]!): \(t.value)] ")
        }
        let fullTask = taskTitle + taskBody
        var json : [String: Any] = [:]
        if isSelectedImage {
            let imageData = image.jpegData(compressionQuality: 1)!.base64EncodedString()
            json = JsonFormat.setTaskWithImage(
                id: defaults.franchiseId()!,
                value: fullTask,
                image: imageData)
                .format()
        }else{
            json = JsonFormat.setTask(
                id: defaults.franchiseId()!,
                value: fullTask)
                .format()
        }
        #warning("TODO add to the databasedelegate file")
        DatabaseDelegate.performRequest(
            with: json,
            ret: returnType.string,
            completion: {
                _ in
                self.presentationMode.wrappedValue.dismiss()
            })
    }
}

extension Binding {
    func unwrap<Wrapped>(def: Binding<Wrapped>)
    -> Binding<Wrapped>?
    where Optional<Wrapped> == Value {
        guard let value = self.wrappedValue else {
            return def
        }
        return Binding<Wrapped>(
            get: {
                return value
            },
            set: { value in
                self.wrappedValue = value
            }
        )
    }
}
