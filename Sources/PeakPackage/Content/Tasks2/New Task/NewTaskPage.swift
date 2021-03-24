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
    
    var body: some View {
        NavigationView{
            List{
                ForEach(forms, id: \.id){
                    form in
                    CardView(
                        id: UUID(),
                        selectionManager: selectionManager,
                        color: Color.lightAccent,
                        icon: Image(systemName: "plus"),
                        title: form.title,
                        sub: "",
                        content: form.subtitle,
                        showMoreInfo: $showForm)
                }
            }
            .CleanList()
            .navigationBarTitle(Text("Request"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    #warning("TODO add task")
                }, label: {
                    if defaults.admin{
                        Image(systemName: "plus.rectangle.fill")
                            .foregroundColor(.darkAccent)
                    }
                })
            )
        }
        .stackOnlyNavigationView()
    }
}

struct NewTaskPage_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskPage(forms: [
            AutoForm(title: "Add Service Page",
                     subtitle: "A service page added to your website",
                     elements: []),
            AutoForm(title: "Social Posts",
                     subtitle: "Design and posting of social posts",
                     elements: [])
        ])
    }
}
