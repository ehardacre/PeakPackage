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
                                (form.admin ?? false) ?
                                "person.crop.circle.fill.badge.checkmark" :
                                "plus"),
                        title: form.title,
                        sub: "",
                        content: form.subtitle,
                        showMoreInfo: $showForm)
                        .sheet(
                            isPresented: $showForm,
                            content: {
                                AutoFormView(showing: $showForm, form: form)
                                    .introspectViewController {
                                        $0.isModalInPresentation = true
                                    }
                                    .onDisappear{
                                        selectionManager.id = nil
                                    }
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
        }
        .stackOnlyNavigationView()
        .sheet(isPresented: $creatingNewForm, content: {
            NewFormView()
        })
    }
    
    private func sortFormsforAdmin() -> [AutoForm]{
        return forms.sorted {
            adminToInt(admin: $0.admin ?? false) < adminToInt(admin: $1.admin ?? false)
        }
    }
    
    private func adminToInt(admin : Bool) -> Int {
        return admin ? 1 : 0
    }
}

struct NewTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskPage(forms: [
            AutoForm(title: "Add Service Page",
                     subtitle: "A service page added to your website",
                     elements: []),
            AutoForm(admin: true,
                     title: "Social Posts",
                     subtitle: "Design and posting of social posts",
                     elements: [])
        ])
    }
}
