//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 5/4/21.
//

import Foundation
import SwiftUI

struct TaskCalendarCardView: View {
    
    var id = UUID()
    @ObservedObject var selectionManager : SelectionManager
    @State var taskManager : TaskManager2
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
                ShortCardView(
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

                    ShortCardView(
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

                    ShortCardView(
                        id: id,
                        selectionManager: selectionManager,
                        color: Color.mid,
                        icon: Image(systemName: "seal.fill"),
                        title: "Requested",
                        sub: self.date,
                        content: self.content,
                        showMoreInfo: $showMoreInfo)

                } else { //open
                    ShortCardView(
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
                    TaskInfoView(manager: taskManager, task: self.task!)
                        .onDisappear{
                            self.selectionManager.id = nil
                        }
                }
        })
    }
}

struct ShortCardView: View {
    
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
    @State var onDeselection : () -> Void = {return}
    
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
                    Text(TaskManager2.parseRequest(content).first?.title ?? "Task")
                        .CardTitle()
                    Spacer()
                    Text(sub)
                        .CardTitle()
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
                onDeselection()
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
