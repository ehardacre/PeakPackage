//
//  LeadInfoSheet.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/6/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import MapKit
import SwiftUI
import UIKit
import MessageUI

struct LeadInfoSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var confirmTrash : Bool = false
    @State var region : MKCoordinateRegion = MKCoordinateRegion()
    @State var annotations : [LeadLocation] = []
    @State var images : [ RemoteImage]
    @State var selectedImage : RemoteImage? = nil
    @State var showFullScreenImage = false
    
    var lead : Lead
    var notificationMan : LeadManager
    var phoneNumber : String?
    var email : String?
    var address : String?
    
    var body: some View {
        VStack{
            Text(lead.notification_key)
                .font(.title2)
                .bold()
                .foregroundColor(Color.darkAccent)
            Divider()
                .frame(width: 250)
            ZStack{
                if annotations.count == 0 {
                    Text("No Address Found")
                        .Caption()
                        .padding(20)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(20.0)
                }else{
                    Map(
                        coordinateRegion: $region,
                        annotationItems: annotations){
                            place in
                            MapMarker(
                                coordinate: place.coordinate,
                                tint: .main)
                    }
                    .frame(height: 200)
                    .cornerRadius(20.0)
                    .onTapGesture(count: 1, perform: {
                        openMaps()
                    })
                }
            }
            Section{
                if address != nil {
                    Text(address!)
                        .font(.footnote)
                        .foregroundColor(Color.darkAccent)
                    Divider()
                }
                if lead.notification_value.job_date != nil {
                    Text(lead.notification_value.job_date!)
                        .font(.footnote)
                        .foregroundColor(Color.darkAccent)
                }
                #warning("TODO all of this broken")
                if images.count != 0 &&
                    defaults.getApplicationType() != .PeakClients(.any){
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(images, id: \.id){ image in
                                image
                                    .cornerRadius(20)
                                    .frame(width: 100, height: 100)
                                    .onTapGesture{
                                        #warning("TODO selected image not changing")
                                        selectedImage = image
                                        showFullScreenImage = true
                                    }
                            }
                            Spacer()
                        }
                        .frame(height: 100)
                    }
                }
            }
            Section{
                if selectedImage != nil {
                    GeometryReader{
                        geo in
                        selectedImage
                            .cornerRadius(20)
                            .frame(width: geo.size.width)
                            .scaledToFit()
                    }
                }else{
                    if lead.notification_value.job_type != nil {
                        HStack{
                            if lead.notification_value.job_type!
                                .contains("Estimate")
                            {
                                Image(
                                    systemName: "dollarsign.square.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.mid)
                            } else if lead.notification_value.job_type!
                                .contains("Work")
                            {
                                Image(
                                    systemName: "paintbrush.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.mid)
                            } else {
                                Image(
                                    systemName: "questionmark.diamond.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.mid)
                            }
                            Text(lead.notification_value.job_type!)
                                .bold()
                                .foregroundColor(Color.darkAccent)
                        }
                        .padding(20)
                    }
                    if lead.notification_value.note != nil {
                        Text(lead.notification_value.note!)
                            .font(.footnote)
                            .foregroundColor(Color.darkAccent)
                    }
                    
                    if lead.notification_value.phone != nil ||
                        lead.notification_value.email != nil ||
                        lead.notification_value.lead_source != nil ||
                        lead.notification_value.technician_name != nil
                    {
                        VStack{
                            Text(lead.notification_value.phone ?? "")
                                .font(.footnote)
                                .foregroundColor(Color.darkAccent)
                            Text(lead.notification_value.email ?? "")
                                .font(.footnote)
                                .foregroundColor(Color.darkAccent)
                            if lead.notification_value.lead_source != nil {
                                Text("Lead Source: " + lead.notification_value.lead_source!)
                                    .font(.footnote)
                                    .foregroundColor(Color.darkAccent)
                            }
                            if lead.notification_value.technician_name != nil {
                                Text("Technician: " + lead.notification_value.technician_name!)
                                    .font(.footnote)
                                    .foregroundColor(Color.darkAccent)
                            }
                        }
                        .padding(20)
                        .background(Color.darkAccent.opacity(0.2))
                        .cornerRadius(20)
                    }
                
                }
            }
            Spacer()
            if defaults.getApplicationType() == .NHanceConnect{
                BottomBar_NHance(
                    email: email,
                    phoneNumber: phoneNumber)
            }else if defaults.getApplicationType() == .PeakClients(.any){
                BottomBar_Peak(
                    id: lead.notification_id,
                    state_str: lead.notification_state,
                    parent: self)
            }
        }
        .onAppear{
            let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address ?? "") {
                    (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                    else {
                        // handle no location found
                        return
                    }
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.2,
                                               longitudeDelta: 0.2))
                    annotations = [LeadLocation(
                                    name: "Lead",
                                    latitude: location.coordinate.latitude,
                                    longitude: location.coordinate.longitude)]
                }
            
        }
        .padding(30)
        .sheet(
            isPresented: $showFullScreenImage,
            onDismiss: {selectedImage = nil}){
                FullScreenImageView(image: selectedImage!)
            }
    }
    
    func dismiss(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func openMaps(){

        let destination = MKMapItem(
            placemark: MKPlacemark(
                coordinate: CLLocationCoordinate2D(
                    latitude: annotations.first!.latitude,
                    longitude: annotations.first!.longitude)))
        destination.name = "\(lead.notification_key)'s Home"

        MKMapItem.openMaps(
            with: [destination],
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    var email : String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([email])
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

struct LeadLocation: Identifiable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
  }

struct FullScreenImageView : View {
    
    @State var image : RemoteImage
    
    var body: some View{
        GeometryReader{ geo in
            VStack{
                Spacer()
                image
                    .frame(width: geo.size.width)
                Spacer()
            }
        }
    }
}
