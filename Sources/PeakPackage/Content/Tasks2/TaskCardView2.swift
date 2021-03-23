//
//  SwiftUIView.swift
//  
//
//  Created by Ethan Hardacre  on 3/23/21.
//

import SwiftUI

struct TaskCardView2: View {
    
    var id = UUID()
    @ObservedObject var selectionManager : SelectionManager
    var task : Task? //allow nil for testing
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
        ZStack{
            if self.type.origin == TaskOrigin.complementary {
                CardView(
                    id: id,
                    selectionManager: selectionManager,
                    color: Color.mid,
                    icon: Image(systemName: "bolt.fill"),
                    title: "Complimentary",
                    sub: self.date,
                    content: self.content,
                    showMoreInfo: $showMoreInfo)
            } else {
                if self.type.status == TaskStatus.complete {

                    CardView(
                        id: id,
                        selectionManager: selectionManager,
                        color: Color.darkAccent,
                        icon: Image(systemName: "checkmark.seal.fill"),
                        iconColor: Color.main,
                        title: "Requested",
                        sub: self.date,
                        content: self.content,
                        showMoreInfo: $showMoreInfo)

                } else if self.type.status == TaskStatus.inProgress {

                    CardView(
                        id: id,
                        selectionManager: selectionManager,
                        color: Color.mid,
                        icon: Image(systemName: "seal.fill"),
                        title: "Requested",
                        sub: self.date,
                        content: self.content,
                        showMoreInfo: $showMoreInfo)

                } else { //open
                    CardView(
                        id: id,
                        selectionManager: selectionManager,
                        color: Color.mid,
                        icon: Image(systemName: "seal"),
                        title: "Requested",
                        sub: self.date,
                        content: self.content,
                        showMoreInfo: $showMoreInfo)
                }
            }
        }
        .sheet(
            isPresented: $showMoreInfo,
            content: {
                if self.task != nil {
                    TaskInfoView(task: self.task!)
                        .onDisappear{
                            self.selectionManager.id = nil
                        }
                }
        })
    }
}

struct TaskCardView2_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView2(
            selectionManager: SelectionManager(),
            task: nil,
            type: TaskType(
                status: TaskStatus.inProgress,
                origin: TaskOrigin.userRequested),
            date: "11/20/20",
            content: "(Service Page Addition for admin) Details include [Service Title: Test Service][Custom Content: Testing new teams update]")
    }
}
