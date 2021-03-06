//
//  PhotoPicker.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 11/11/2021.
//

import PhotosUI
import SwiftUI

// A system photo picker that lets the user select a photo from their library.
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Only allow the user to select from images from the shared photo library.
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images

        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = context.coordinator

        return photoPicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(photoPicker: self)
    }
}

extension PhotoPicker {
    final class Coordinator: PHPickerViewControllerDelegate {
        private let photoPicker: PhotoPicker

        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            // Try and get the image asset that the user has selected, if there was one.
            guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self)
            else { return }

            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                Task { @MainActor in
                    self.photoPicker.image = image as? UIImage
                }
            }
        }
    }
}

struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(image: .constant(nil))
            .ignoresSafeArea()
    }
}
