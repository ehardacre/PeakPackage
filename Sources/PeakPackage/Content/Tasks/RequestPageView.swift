//
//  RequestPageView.swift
//  Peak Client
//
//  Created by Ethan Hardacre on 6/12/20.
//  Copyright © 2020 Peak Studios. All rights reserved.
//
//
//import SwiftUI
//import Pages
//import SwiftUIRefresh
//
//
////MARK: Request Page View
////view for showing open and closed requests
//
//struct RequestPageView: View {
//    
//    //the content view that controls this request page
//    var taskMan : TaskManager
//    //the status of the tasks being shown
//    var status : TaskStatus
//    //list of views for tasks
//    var tasks : [TaskCardView] = []
//    
//    @ObservedObject var selectionManager = SelectionManager()
//    
//    /**
//     #Request Page View
//        holds the whole view for task views
//     */
//    init(
//        taskMan: TaskManager,
//        tasklist: [Task],
//        status: TaskStatus) {
//        self.taskMan = taskMan
//        self.status = status
//        tasks = convert(tasks: tasklist)
//    }
//    
//    /**
//        # convert : converts tasks to views
//     - Parameter tasks : the tasks to be converted to task card views
//            TODO: make an extension of task
//     */
//    func convert(tasks: [Task]) -> [TaskCardView] {
////        //empty list of cards
////        var cards : [TaskCardView] = []
////        //loop through tasks and individually convert them
////        for task in tasks {
////            cards.append(task.convertToCard(with: selectionManager))
////        }
////        return cards.reversed()
//        return []
//        //depricated
//    }
//    
//    var body: some View {
//        ZStack(alignment: .topTrailing){
//            //add the actual list with the task cards
//            RequestListView(
//                taskMan: taskMan,
//                selectionManager: selectionManager,
//                status: status,
//                tasks: tasks)
//        }
//    }
//}
//
////MARK: RequestListView
////the view for displaying the list of cards
//
//struct RequestListView: View {
//    
//    //taskMan view to update
//    var taskMan : TaskManager
//    @ObservedObject var selectionManager : SelectionManager
//    //list of cards
//    var status : TaskStatus
//    @State var tasks : [TaskCardView]
//    //is the user making a new task
//    @State var makingNewTask = false
//    //information about the service request
//    @State var serviceDesc: String = ""
//    @State var franchiseName: String = ""
//    @State var formTypes = [Form_Type]()
//    @State var refreshShowing = false
//    @State var navbarTitle = ""
//    @State var refreshing = false
//    
//    var body: some View {
//        NavigationView{
//            List{
//                ForEach(self.tasks, id: \.id) {
//                    task in
//                    task
//                        .listRowBackground(Color.clear)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                .listRowBackground(Color.clear)
//                .listStyle(SidebarListStyle())
//                .environment(\.defaultMinListRowHeight, 120)
//                .padding(0.0)
//            }
//            .listStyle(SidebarListStyle())
//            .environment(\.defaultMinListRowHeight, 120)
//            .padding(0.0)
//            .navigationBarTitle(self.navbarTitle)
//            //button for adding a new task
//                .navigationBarItems(
//                    trailing: Button(
//                        action: {
//                            self.makingNewTask = true
//                        }){
//                            if self.status == TaskStatus.open {
//                                Text("+")
//                                    .bold()
//                                    .font(.title)
//                                    .foregroundColor(Color.darkAccent)
//                            }
//                    })
//                    .background(Color.clear)
//        }
//        .background(Color.clear)
//        .stackOnlyNavigationView()
//        .onAppear{
//            if status == TaskStatus.open {
//                navbarTitle = "Service Requests"
//            }else if status == TaskStatus.complete {
//                navbarTitle = "Complete"
//            }else{
//                navbarTitle = "In Progress"
//            }
//        }
//        .pullToRefresh(isShowing: $refreshing){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                taskMan.loadTasks()
//                self.refreshing = false
//            }
//        }
//        .sheet(isPresented: $makingNewTask){
//            VStack{
//                NavigationView{
//                    List{
//                        ForEach (
//                            self.formTypes,
//                            id: \.id) {
//                            formType in
//                            NavigationLink(
//                                destination:
//                                    AutoServeView(title: formType.name,
//                                                  formId: formType.id,
//                                                  franchise: self.franchiseName)){
//                                Text(formType.name)
//                            }
//                        }
//                    }
//                    .onAppear{
//                        let json = JsonFormat.getDynamicFormTypes(id: defaults.franchiseId()!).format()
//                        #warning("TODO move to dbdelegate file")
//                        DatabaseDelegate.performRequest(
//                            with: json,
//                            ret: returnType.formtype,
//                            completion: {
//                                rex in
//                                self.formTypes = rex as! [Form_Type]
//                        })
//                    }
//                    .navigationBarTitle("Request Service")
//                    .navigationBarItems(
//                        leading:
//                            Button(action: {
//                                self.makingNewTask = false
//                            }){
//                                Text("Cancel")
//                                    .foregroundColor(Color.gray)
//                            }
//                    )
//                }
//                
//            }
//        }.onAppear(
//            perform: {
//                self.franchiseName = defaults.franchiseName()!
//        })
//    }
//    
//    //submits a new service request 
//    func submitNewRequest(){
////        //get the information from defaults
////        let name = defaults.getUsername()!
////        let fname = franchiseName
////        let fid = defaults.franchiseId()!
////        //formatting the description based on info
////        let reqDesc = "\(fname) (\(name)): \(serviceDesc)"
////        //format the json for a new task
////        let json = JsonFormat.setTask(id: fid, value: reqDesc).format()
////        #warning("TODO move to dbdelegate file")
////        //actually submit the new task
////        DatabaseDelegate.performRequest(
////            with: json,
////            ret: returnType.string,
////            completion: {
////                rex in
////                //if the return type is not correct then an error has occurred
////                if (rex as! String) != "Array"{
////                    printr(DataError.failedRequest.rawValue,
////                           tag: printTags.error)
////                }
////                self.taskMan.resetTasks()
////        })
//    }
//}
