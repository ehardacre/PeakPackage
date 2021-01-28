//
//  TaskCardView.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/10/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//

import SwiftUI

//MARK: Task Card View

class SelectionManager: ObservableObject {
    @Published var id : UUID?
}

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
        GeometryReader{ geo in
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.lightAccent)
                .frame(height: self.height)
                .overlay(
                    HStack{
                        ZStack{
                            //determines the image that is placed on the left side of the card
                            if self.type.origin == TaskOrigin.complementary {
                                Rectangle().fill(Color.mid).frame(width: 50.0)
                                Image("bolt").resizable().frame(width:40,height:40).foregroundColor(Color.darkAccent)
                            } else {
                                if self.type.status == TaskStatus.complete {
                                    Rectangle().fill(Color.darkAccent).frame(width: 50.0)
                                    Image("done").resizable().frame(width:40,height:40).opacity(0.5).foregroundColor(Color.lightAccent)
                                }else if self.type.status == TaskStatus.open {
                                    Rectangle().fill(Color.mid).frame(width: 50.0)
                                    Image("add").resizable().frame(width:40,height:40).opacity(0.5).foregroundColor(Color.black)
                                }
                            }
                            
                        //ZSTACK end
                        }
                        
                        //displaying the content on the card
                            VStack(alignment: .leading) {
                                
                                    Text(self.type.origin == TaskOrigin.userRequested ? "Requested" : self.type.origin.rawValue)
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Text(self.date)
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(.primary)
                                        .lineLimit(3)
                                    Text(self.content.uppercased())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .truncationMode(.tail)
                                        .lineLimit(1)
                                    
                                
                            //VSTACK end
                            }
                        
                        Spacer()
                        
                        
                        
                    //HSTACK
                    }.frame(width: geo.size.width, height: self.height)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke((self.id == self.selectionManager.id) ? Color.blue : Color.mid, lineWidth: (self.id == self.selectionManager.id) ? 3 : 1))
                        //OVERLAY end
                        )
                .onTapGesture(count: 2, perform: {
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
            .sheet(isPresented: self.$showMoreInfo, content: {
                TaskDetails(task: self.task).onDisappear{
                    self.selectionManager.id = nil
                }
            })
        }
    
    }