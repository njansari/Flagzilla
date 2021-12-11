//
//  CameraPicker.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/11/2021.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = context.coordinator
        cameraPicker.sourceType = .camera
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

            if let image = info[.editedImage] as? UIImage {
                cameraPicker.image = image
            }
        }
    }
}
