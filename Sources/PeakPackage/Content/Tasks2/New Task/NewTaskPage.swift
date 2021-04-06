//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI

struct NewTaskPage: View {
    
    let selectionManager = SelectionManager()
    
    @Environment(\.presentationMode) var presentationMode
    @State var forms : [AutoForm]
    @State var showForm = false
    @State var creatingNewForm = false
    @State var selectedForm : visibleAutoForm? = nil
    
    var body: some View {
        NavigationView{
            List{
                ForEach(sortFormsforAdmin(), id: \.id){
                    form in
                        CardView(
                            id: UUID(),
                            selectionManager: selectionManager,
                            color: Color.lightAccent,
                            icon:
                            Image(systemName:
                                    (form.vis) == "admin" ?
                                    "person.crop.circle.fill.badge.checkmark" :
                                    "plus"),
                            title: form.title,
                            sub: "",
                            content: form.subtitle,
                            showMoreInfo: $showForm,
                            onSelection: {
                                showForm = true
                                selectedForm = form
                                return
                            })
                }
            }
            .CleanList()
            .navigationBarTitle(Text("Request"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    creatingNewForm = true
                }, label: {
                    if defaults.admin{
                        Image(systemName: "plus.rectangle.fill")
                            .foregroundColor(.darkAccent)
                    }
                })
            )
            .sheet(item: $selectedForm, content: { newForm in
                AutoFormView(form: newForm,
                             dismissFunction: {
                                selectionManager.id = nil
                                selectedForm = nil
                })
                    .introspectViewController {
                        $0.isModalInPresentation = true
                    }
            })
        }
        .stackOnlyNavigationView()
        .sheet(isPresented: $creatingNewForm, content: {
            NewFormView(allforms: $forms, showing: $creatingNewForm)
        })
    }
    
    private func sortFormsforAdmin() -> [visibleAutoForm]{
        return forms.sorted {
            $0.vis < $1.vis
        }.map({$0.visibleForm()})
    }
}

struct NewTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskPage(forms: [
            AutoForm(visibility: nil,
                     title: "Add Service Page",
                     subtitle: "A service page added to your website",
                     elements: []),
            AutoForm(visibility: "admin",
                     title: "Social Posts",
                     subtitle: "Design and posting of social posts",
                     elements: [])
        ])
    }
}
