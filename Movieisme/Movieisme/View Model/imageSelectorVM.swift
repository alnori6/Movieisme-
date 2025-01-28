//
//  imageSelectorVM.swift
//  Movieisme
//
//  Created by Noori on 28/01/2025.
//

import SwiftUI
import UIKit

class imageSelectorVM: NSObject, ObservableObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented: Bool = false
    
    private let imagePicker = UIImagePickerController()
    
    override init() {
        super.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    func presentImagePicker() {
        isImagePickerPresented = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        }
        isImagePickerPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isImagePickerPresented = false
    }
}
