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

    var imagePreviewBorder: some View {
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(.tertiary, lineWidth: 2)
    }

    var photoLibraryButton: some View {
        Button {
            showingPhotoPicker = true
            resetResults()
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }
    }

    var takePhotoButton: some View {
        Button {
            showingCameraPicker = true
            resetResults()
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }

    var chooseFileButton: some View {
        Button {
            showingFilePicker = true
            resetResults()
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
                            .scaledToFill()
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(width: 299, height: 299)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)

                selectImageMenu
            }
            .padding(.vertical)
        }
        .listRowBackground(imagePreviewBorder)
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

    var displayedResults: [VNClassificationObservation] {
        guard let classificationResults = classificationResults else { return [] }

        if resultsExpanded {
            let suitable = classificationResults.prefix { $0.confidence > 0.001 }
            return Array(classificationResults.prefix(min(5, suitable.count)))
        } else {
            return Array(classificationResults.prefix(1))
        }
    }

    var resultsSection: some View {
        Section("Results") {
            if displayedResults.isEmpty {
                Text("There were no flags detected")
                    .fontWeight(.medium)
            } else {
                ForEach(displayedResults, id: \.self) { result in
                    HStack {
                        Text(result.identifier)

                        Spacer()

                        Text(result.confidence, format: .percent.precision(.significantDigits(3)))
                            .foregroundStyle(.secondary)
                    }
                    .font(result == classificationResults?.first ? .body.bold() : .body)
                }

                if classificationResults?.count ?? 0 > 1 && !resultsExpanded {
                    Button("See alternative suggestions…") {
                        resultsExpanded = true
                    }
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

    func resetResults() {
        classificationResults = nil
        resultsExpanded = false
    }

    func showErrorAlert(message: String) {
        errorMessage = message
        showingErrorAlert = true
    }

    func classifyFlags() {
        guard let selectedImage = selectedImage,
              let cgImage = selectedImage.cgImage
        else {
            showErrorAlert(message: "The image couldn't be prepared")
            return
        }

        guard let classifier = try? FlagClassifier(configuration: .init()),
              let model = try? VNCoreMLModel(for: classifier.model)
        else {
            showErrorAlert(message: "The machine learning model couldn't be created")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results,
                  let classifications = results as? [VNClassificationObservation]
            else {
                showErrorAlert(message: error?.localizedDescription ?? "")
                return
            }

            classificationResults = classifications
            isClassifying = false
        }

        request.imageCropAndScaleOption = .centerCrop

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
