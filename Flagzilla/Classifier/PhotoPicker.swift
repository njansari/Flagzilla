//
//  PhotoPicker.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 11/11/2021.
//

import PhotosUI
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
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
    class Coordinator: PHPickerViewControllerDelegate {
        let photoPicker: PhotoPicker

        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                let previousImage = photoPicker.image

                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self,
                          let image = image as? UIImage,
                          self.photoPicker.image == previousImage
                    else { return }

                    self.photoPicker.image = image
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
