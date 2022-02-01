//
//  CameraPicker.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/11/2021.
//

import SwiftUI

// A system camera picker that lets the user take a picture and resize it.
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = context.coordinator
        cameraPicker.sourceType = .camera

        // Allow the user to crop the photo they took to give it a 1:1 aspect ratio.
        // This matches what the flag classifier model expects the image's frame to have.
        cameraPicker.allowsEditing = true

        return cameraPicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(cameraPicker: self)
    }
}

extension CameraPicker {
    @MainActor final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let cameraPicker: CameraPicker

        init(cameraPicker: CameraPicker) {
            self.cameraPicker = cameraPicker
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            picker.dismiss(animated: true)
            cameraPicker.image = info[.editedImage] as? UIImage
        }
    }
}
