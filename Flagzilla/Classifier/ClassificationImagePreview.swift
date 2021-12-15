//
//  ClassificationImagePreview.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import SwiftUI
import Vision

struct ClassificationImagePreview: View {
    @ObservedObject private(set) var classifier: FlagImageClassifier

    @State private var showingPhotoPicker = false
    @State private var showingCameraPicker = false
    @State private var showingFilePicker = false
    @Binding var resultsExpanded: Bool

    private var imagePreviewBorder: some View {
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(.tertiary, lineWidth: 2)
    }

    private var photoLibraryButton: some View {
        Button {
            showingPhotoPicker = true
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }
    }

    private var takePhotoButton: some View {
        Button {
            showingCameraPicker = true
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }

    private var chooseFileButton: some View {
        Button {
            showingFilePicker = true
        } label: {
            Label("Choose File", systemImage: "folder")
        }
    }

    private var selectImageMenu: some View {
        Menu("\(classifier.selectedImage == nil ? "Select" : "Change") Image") {
            photoLibraryButton

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                takePhotoButton
            }

            chooseFileButton
        }
    }

    private var imageScaleButton: some View {
        Menu {
            Picker("Image scale option", selection: $classifier.imageScaleOption.animation()) {
                Text("Centre Crop")
                    .tag(VNImageCropAndScaleOption.centerCrop)

                Text("Scale Fill")
                    .tag(VNImageCropAndScaleOption.scaleFill)

                Text("Scale Fit")
                    .tag(VNImageCropAndScaleOption.scaleFit)
            }
        } label: {
            Label("Image scale options", systemImage: "aspectratio")
                .labelStyle(.iconOnly)
        }
    }

    private var imagePreview: some View {
        Group {
            if let selectedImage = classifier.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(options: classifier.imageOptions)
                    .frame(width: 299, height: 299, alignment: classifier.imageOptions.alignment)
                    .clipped()
                    .border(.primary)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
    }

    var body: some View {
        Section {
            VStack(spacing: 20) {
                imagePreview

                HStack {
                    Spacer()

                    selectImageMenu

                    if classifier.selectedImage != nil {
                        Spacer()
                        imageScaleButton
                    }

                    Spacer()
                }
                .animation(nil, value: classifier.selectedImage)
            }
            .padding(.vertical)
        } footer: {
            if classifier.imageScaleOption == .scaleFit {
                Text("Any remaining space is filled with transparent pixels.")
            }
        }
        .listRowBackground(imagePreviewBorder)
        .onChange(of: classifier.selectedImage, perform: resetResults)
        .onChange(of: classifier.imageScaleOption, perform: resetResults)
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(image: $classifier.selectedImage.animation())
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showingCameraPicker) {
            CameraPicker(image: $classifier.selectedImage.animation())
                .ignoresSafeArea()
        }
        .fileImporter(isPresented: $showingFilePicker, allowedContentTypes: [.image], onCompletion: importImage)
    }

    private func resetResults(_: Any) {
        classifier.classificationResults = nil
        resultsExpanded = false
    }

    private func importImage(result: Result<URL, Error>) {
        do {
            let url = try result.get()

            if url.startAccessingSecurityScopedResource() {
                let data = try Data(contentsOf: url)

                withAnimation {
                    classifier.selectedImage = UIImage(data: data)
                }
            }

            url.stopAccessingSecurityScopedResource()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ClassificationImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationImagePreview(classifier: FlagImageClassifier(), resultsExpanded: .constant(true))
    }
}
