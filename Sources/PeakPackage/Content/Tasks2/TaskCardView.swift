//
//  TaskCardView.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/10/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Task Card View

//class SelectionManager: ObservableObject {
//    @Published var id : UUID?
//}

struct TaskCardView: View {
    
    //needs an id as an identifier for list
    var id = UUID()
    @ObservedObject var selectionManager : SelectionManager
    var task : Task
    //the type of the task is passed as an argument
    var type : TaskType
    //Information
    var date : String
    var content : String
    @State var statusIndex = 0
    let statusOptions = ["Open", "In Progress", "Complete"]
    //height of the row
    var height : CGFloat = 105
    @State var showMoreInfo = false
    
    var body: some View {
        //UI elements
        GeometryReader{
            geo in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.lightAccent)
                .background(Color.clear)
                .frame(height: self.height)
                .overlay(
                    HStack{
                        ZStack{
                            //determines the image that is placed on the left side of the card
                            if self.type.origin == TaskOrigin.complementary {
                                Rectangle()
                                    .fill(Color.mid)
                                    .frame(width: 50.0)
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(Color.darkAccent)
                            } else {
                                if self.type.status == TaskStatus.complete {
                                    Rectangle()
                                        .fill(Color.darkAccent)
                                        .frame(width: 50.0)
                                    Image(systemName: "checkmark")
                                        .opacity(0.5)
                                        .foregroundColor(Color.lightAccent)
                                }else { // if self.type.status == TaskStatus.open
                                    Rectangle()
                                        .fill(Color.mid)
                                        .frame(width: 50.0)
                                    Image(systemName: "square.stack.3d.up")
                                        .opacity(0.5)
                                        .foregroundColor(Color.black)
                                }
                            }
                        }
                        //displaying the content on the card
                        VStack(alignment: .leading) {
                            HStack{
                                Text(self.type.origin == TaskOrigin.userRequested ?
                                        "Requested" : self.type.origin.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(self.date)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            Text(self.content.uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .truncationMode(.tail)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: self.height)
                    .cornerRadius(10)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((self.id == self.selectionManager.id) ?
                                        Color.main : Color.mid,
                                    lineWidth: (self.id == self.selectionManager.id) ?
                                        3 : 1))
                            .background(Color.clear)
                            .foregroundColor(Color.clear)
                    )
                    .onTapGesture(count: 1, perform: {
                        if self.id == self.selectionManager.id {
                            self.selectionManager.id = nil
                        }else{
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            self.selectionManager.id = self.id
                            self.showMoreInfo = true
                        }
                    })
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background(Color.clear)
            .sheet(
                isPresented: self.$showMoreInfo,
                content: {
                TaskDetails(task: self.task)
                    .onDisappear{
                        self.selectionManager.id = nil
                    }
            })
    }
}


struct TaskCardView_Preview : PreviewProvider {
    static var previews: some View {
        TaskCardView(
            selectionManager: SelectionManager(),
            task: Task(
                taskId: "1",
                request: "",
                date: "",
                status: "",
                type: ""),
            type: TaskType(
                status: TaskStatus.inProgress,
                origin: TaskOrigin.userRequested),
            date: "11/20/20",
            content: "(Service Page Addition for admin) Details include [Service Title: Test Service][Custom Content: Testing new teams update]")
    }
}

