//
//  FlagClassifierView.swift
//  FlagClassifierView
//
//  Created by Nayan Jansari on 11/09/2021.
//

import SwiftUI
import Vision

typealias ImageScaleOptionsConfiguration = (aspectRatio: CGFloat?, contentMode: ContentMode, alignment: Alignment)

struct FlagClassifierView: View {
    @State private var selectedImage: UIImage?
    @State private var imageScaleOption: VNImageCropAndScaleOption = .centerCrop
    @State private var isClassifying = false

    @State private var showingPhotoPicker = false
    @State private var showingCameraPicker = false
    @State private var showingFilePicker = false

    @State private var showingErrorAlert = false
    @State private var errorMessage = ""

    @State private var comparisonCountry: Country?

    @State private var classificationResults: [VNClassificationObservation]?
    @State private var resultsExpanded = false

    @Namespace private var imageNamespace

    private var imagePreviewBorder: some View {
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(.tertiary, lineWidth: 2)
    }

    private var photoLibraryButton: some View {
        Button {
            showingPhotoPicker = true
            resetResults()
        } label: {
            Label("Photo Library", systemImage: "photo.on.rectangle")
        }
    }

    private var takePhotoButton: some View {
        Button {
            showingCameraPicker = true
            resetResults()
        } label: {
            Label("Take Photo", systemImage: "camera")
        }
    }

    private var chooseFileButton: some View {
        Button {
            showingFilePicker = true
            resetResults()
        } label: {
            Label("Choose File", systemImage: "folder")
        }
    }

    private var selectImageMenu: some View {
        Menu("\(selectedImage == nil ? "Select" : "Change") Image") {
            photoLibraryButton

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                takePhotoButton
            }

            chooseFileButton
        }
    }

    private var imageScaleButton: some View {
        Menu {
            Picker("Image scale option", selection: $imageScaleOption.animation()) {
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
        .onChange(of: imageScaleOption) { _ in resetResults() }
    }

    private var imageOptionsConfig: ImageScaleOptionsConfiguration {
        let aspectRatio: CGFloat? = imageScaleOption == .scaleFill ? 1 : nil
        let contentMode: ContentMode = imageScaleOption == .scaleFit ? .fit : .fill
        let alignment: Alignment = imageScaleOption == .scaleFit ? .topLeading : .center

        return (aspectRatio, contentMode, alignment)
    }

    private var selectedImageSection: some View {
        Section {
            VStack(spacing: 20) {
                Group {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(imageOptionsConfig.aspectRatio, contentMode: imageOptionsConfig.contentMode)
                            .frame(width: 299, height: 299, alignment: imageOptionsConfig.alignment)
                            .clipped()
                            .matchedGeometryEffect(id: comparisonCountry, in: imageNamespace, properties: .size, isSource: true)
                            .border(.primary)
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)

                HStack {
                    Spacer()

                    selectImageMenu

                    if selectedImage != nil {
                        Spacer()

                        imageScaleButton
                    }

                    Spacer()
                }
                .animation(nil, value: selectedImage)
            }
            .padding(.vertical)
        } footer: {
            if imageScaleOption == .scaleFit {
                Text("Any remaining space is filled with transparent pixels.")
            }
        }
        .listRowBackground(imagePreviewBorder)
    }

    private var startButton: some View {
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

    private var displayedResults: [VNClassificationObservation] {
        guard let classificationResults = classificationResults else { return [] }
        return Array(classificationResults.prefix(resultsExpanded ? 5 : 1))
    }

    private var resultsSection: some View {
        Section {
            if displayedResults.isEmpty {
                Text("There were no flags detected")
                    .fontWeight(.medium)
            } else {
                ForEach(displayedResults, id: \.self) { result in
                    HStack(spacing: 20) {
                        Button {
                            withAnimation {
                                comparisonCountry = countries.first { $0.name == result.identifier } ?? .example
                            }
                        } label: {
                            Label("Compare", systemImage: "arrow.left.arrow.right")
                                .labelStyle(.iconOnly)
                        }

                        Text(result.identifier)

                        Spacer(minLength: 40)

                        Text(result.confidence, format: .percent.precision(.significantDigits(3)))
                            .foregroundStyle(.secondary)
                    }
                    .font(result == classificationResults?.first ? .body.bold() : .body)
                }

            }
        } header: {
            Text("Best Matches")
        } footer: {
            if classificationResults?.count ?? 0 > 1 && !resultsExpanded {
                Button("Show additional suggestions") {
                    withAnimation {
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
                PhotoPicker(image: $selectedImage.animation())
                    .ignoresSafeArea()
            }
            .fullScreenCover(isPresented: $showingCameraPicker) {
                CameraPicker(image: $selectedImage.animation())
                    .ignoresSafeArea()
            }
            .fileImporter(isPresented: $showingFilePicker, allowedContentTypes: [.image], onCompletion: importImage)
        }
        .overlay {
            if let country = comparisonCountry, let selectedImage = selectedImage {
                ZStack(alignment: .topTrailing) {
                    VStack {
                        Spacer()

                        VStack {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(imageOptionsConfig.aspectRatio, contentMode: imageOptionsConfig.contentMode)
                                .frame(width: 299, height: 299)
                                .clipped()
                                .matchedGeometryEffect(id: comparisonCountry, in: imageNamespace, properties: .size, isSource: false)

                            Text("Selected Image")
                        }

                        Spacer()

                        VStack {
                            image(for: country)
                                .frame(width: 299)

                            Text("Suggested Flag")
                        }

                        Spacer()
                    }
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    CloseButton {
                        withAnimation {
                            comparisonCountry = nil
                        }
                    }
                    .frame(width: 32, height: 32)
                    .padding()
                }
                .background(.thinMaterial)
            }
        }
    }

    private func resetResults() {
        classificationResults = nil
        resultsExpanded = false
    }

    private func showErrorAlert(message: String) {
        errorMessage = message
        showingErrorAlert = true
    }

    private func classifyFlags() {
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

            withAnimation {
                classificationResults = classifications.filter { $0.confidence >= 0.001 }
            }

            isClassifying = false
        }

        request.imageCropAndScaleOption = imageScaleOption

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        Task {
            try? requestHandler.perform([request])
        }
    }

    private func importImage(result: Result<URL, Error>) {
        do {
            let url = try result.get()

            if url.startAccessingSecurityScopedResource() {
                let data = try Data(contentsOf: url)

                withAnimation {
                    selectedImage = UIImage(data: data)
                }
            }

            url.stopAccessingSecurityScopedResource()
        } catch {
            print(error.localizedDescription)
        }
    }

    func image(for country: Country) -> some View {
        AsyncFlagImage(url: country.smallFlag, animation: .easeIn(duration: 0.1)) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(2)
                .shadow(color: .primary.opacity(0.4), radius: 2)
        } placeholder: {
            RoundedRectangle(cornerRadius: 2)
                .fill(.quaternary)
                .frame(height: 118)
        }
    }
}

struct FlagClassifierView_Previews: PreviewProvider {
    static var previews: some View {
        FlagClassifierView()
    }
}
