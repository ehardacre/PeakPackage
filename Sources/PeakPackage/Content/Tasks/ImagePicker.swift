//
//  ImagePicker.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 9/30/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) var presentationMode
    var onComplete : ()->Void
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ImagePicker>)
    -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onComplete: onComplete)
    }
}

final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePicker
    var onComplete: ()->Void

    init(_ parent: ImagePicker, onComplete: @escaping ()->Void) {
        self.parent = parent
        self.onComplete = onComplete
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedImage = image
        }
        parent.presentationMode.wrappedValue.dismiss()
        onComplete()
    }
}
