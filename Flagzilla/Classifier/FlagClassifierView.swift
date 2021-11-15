//
//  FlagClassifierView.swift
//  FlagClassifierView
//
//  Created by Nayan Jansari on 11/09/2021.
//

import SwiftUI

struct FlagClassifierView: View {
    @State private var selectedImage: UIImage?

    @State private var showingPhotoPicker = false
    @State private var showingCameraPicker = false
    @State private var showingFilePicker = false

    var imagePreviewBackground: some View {
        GeometryReader { geometry in
            let cornerRadius = 10.0
            let perimeter = 2 * (geometry.size.width + geometry.size.height + cornerRadius * (.pi - 4))
            let strokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, dash: [perimeter / 100])

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(.tertiary, style: strokeStyle)
        }
    }

    var photoLibraryButton: some View {
        Button {
            showingPhotoPicker = true
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }
    }

    var takePhotoButton: some View {
        Button {
            showingCameraPicker = true
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }

    var chooseFileButton: some View {
        Button {
            showingFilePicker = true
        } label: {
            Label("Choose File", systemImage: "folder")
        }
    }

    var selectImageMenu: some View {
        Menu("\(selectedImage == nil ? "Select" : "Change") Image") {
            photoLibraryButton

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                takePhotoButton
            }

            chooseFileButton
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(spacing: 20) {
                        Group {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                            } else {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)

                        selectImageMenu
                    }
                    .padding(.vertical)
                }
                .listRowBackground(imagePreviewBackground)

                Button("Start Classification") {

                }
                .buttonStyle(.listRow)
            }
            .navigationTitle("Flag Classifier")
            .sheet(isPresented: $showingPhotoPicker) {
                PhotoPicker(image: $selectedImage)
                    .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $showingCameraPicker) {
                CameraPicker(image: $selectedImage)
                    .ignoresSafeArea()
            }
            .fileImporter(isPresented: $showingFilePicker, allowedContentTypes: [.image]) { result in
                do {
                    let url = try result.get()

                    if url.startAccessingSecurityScopedResource() {
                        let data = try Data(contentsOf: url)
                        selectedImage = UIImage(data: data)
                    }

                    url.stopAccessingSecurityScopedResource()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct FlagClassifierView_Previews: PreviewProvider {
    static var previews: some View {
        FlagClassifierView()
    }
}
