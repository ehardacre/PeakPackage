//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI

class SelectionManager: ObservableObject {
    @Published var id : UUID?
}

struct CardView: View {
    
    @State var id : UUID
    @ObservedObject var selectionManager : SelectionManager
    @State var color : Color
    @State var icon : Image
    @State var iconColor : Color = Color.darkAccent
    @State var title : String
    @State var sub : String
    @State var content : String
    @Binding var showMoreInfo : Bool
    @State var onSelection : () -> Void = {return}
    
    var body: some View {
        HStack{
            ZStack{
                Rectangle()
                    .fill(color)
                    .frame(width: 100)
                icon
                    .imageScale(.large)
                    .foregroundColor(iconColor)
            }
            VStack{
                HStack{
                    Text(title)
                        .CardTitle()
                    Spacer()
                    Text(sub)
                        .CardTitle()
                }
                Divider()
                    .padding(10.0)
                HStack{
                    Text(content.uppercased())
                        .Caption()
                    Spacer()
                }
            }
            .padding(.horizontal, 10.0)
        }
        .background(Color.lightAccent)
        .overlay(
            RoundedRectangle(cornerRadius: 20.0)
                .stroke(
                    (self.id == self.selectionManager.id) ?
                            Color.main : Color.clear,
                        lineWidth: (self.id == self.selectionManager.id) ?
                            3 : 1)
                .background(Color.clear)
                .foregroundColor(Color.clear)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .onTapGesture(count: 1, perform: {
            if self.id == self.selectionManager.id {
                self.selectionManager.id = nil
            }else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.selectionManager.id = self.id
                self.showMoreInfo = true
                onSelection()
            }
        })
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            id: UUID(),
            selectionManager: SelectionManager(),
            color: Color.pink,
            icon: Image(systemName: "scribble.variable"),
            title: "Requested",
            sub: "10/20/30",
            content: "this is some test content for ya, what does it look like?",
            showMoreInfo: .constant(false)
            )
            .frame(height: 120)
    }
}
