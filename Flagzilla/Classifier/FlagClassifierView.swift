//
//  FlagClassifierView.swift
//  FlagClassifierView
//
//  Created by Nayan Jansari on 11/09/2021.
//

import SwiftUI
import Vision

struct FlagClassifierView: View {
    @State private var selectedImage: UIImage?
    @State private var isClassifying = false

    @State private var showingPhotoPicker = false
    @State private var showingCameraPicker = false
    @State private var showingFilePicker = false

    @State private var showingErrorAlert = false
    @State private var errorMessage = ""

    @State private var classificationResults: [VNClassificationObservation]?
    @State private var resultsExpanded = false

    var imagePreviewBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(.tertiary, lineWidth: 2)
    }

    var photoLibraryButton: some View {
        Button {
            classificationResults = nil
            showingPhotoPicker = true
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }
    }

    var takePhotoButton: some View {
        Button {
            classificationResults = nil
            showingCameraPicker = true
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }

    var chooseFileButton: some View {
        Button {
            classificationResults = nil
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

    var selectedImageSection: some View {
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
    }

    var startButton: some View {
        Button {
            isClassifying = true
            classifyFlags()
        } label: {
            if isClassifying {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Start Classification")
            }
        }
        .buttonStyle(.listRow)
        .disabled(selectedImage == nil)
        .alert("Couldn't classify image", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) {
                isClassifying = false
            }
        } message: {
            Text(errorMessage)
        }
    }

    var resultsSection: some View {
        Section("Results") {
            ForEach(classificationResults?.prefix(resultsExpanded ? 5 : 1) ?? [], id: \.self) { result in
                HStack {
                    Text(result.identifier)
                        .fontWeight(result == classificationResults?.first ? .bold : .regular)

                    Spacer()

                    Text(result.confidence, format: .percent.precision(.significantDigits(3)))
                        .foregroundStyle(.secondary)
                }
            }

            if !resultsExpanded {
                Button("See alternative suggestions…") {
                    resultsExpanded = true
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                selectedImageSection

                if classificationResults == nil {
                    startButton
                } else {
                    resultsSection
                }
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
            .fileImporter(isPresented: $showingFilePicker, allowedContentTypes: [.image], onCompletion: importImage)
        }
    }

    func classifyFlags() {
        guard let selectedImage = selectedImage,
              let cgImage = selectedImage.cgImage
        else {
            errorMessage = "The image couldn't be prepared"
            showingErrorAlert = true

            return
        }

        guard let classifier = try? FlagClassifier(configuration: .init()),
              let model = try? VNCoreMLModel(for: classifier.model)
        else {
            errorMessage = "The machine learning model couldn't be created"
            showingErrorAlert = true

            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results else {
                errorMessage = error?.localizedDescription ?? ""
                showingErrorAlert = true

                return
            }

            guard let classifications = results as? [VNClassificationObservation] else { return }
            classificationResults = classifications

            isClassifying = false
        }

        request.imageCropAndScaleOption = .scaleFit

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        Task {
            try? requestHandler.perform([request])
        }
    }

    func importImage(result: Result<URL, Error>) {
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

struct FlagClassifierView_Previews: PreviewProvider {
    static var previews: some View {
        FlagClassifierView()
    }
}
