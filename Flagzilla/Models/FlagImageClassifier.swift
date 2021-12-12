//
//  FlagImageClassifier.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import SwiftUI
import Vision

@MainActor class FlagImageClassifier: ObservableObject {
    struct ImageScaleOptions {
        let aspectRatio: CGFloat?
        let contentMode: ContentMode
        let alignment: Alignment
    }

    @Published var selectedImage: UIImage?
    @Published var imageScaleOption: VNImageCropAndScaleOption = .centerCrop
    @Published var isClassifying = false

    @Published var classificationResults: [VNClassificationObservation]?

    @Published var showingErrorAlert = false
    @Published var classificationError: ClassificationError?

    var imageOptions: ImageScaleOptions {
        let aspectRatio: CGFloat? = imageScaleOption == .scaleFill ? 1 : nil
        let contentMode: ContentMode = imageScaleOption == .scaleFit ? .fit : .fill
        let alignment: Alignment = imageScaleOption == .scaleFit ? .topLeading : .center

        return ImageScaleOptions(aspectRatio: aspectRatio, contentMode: contentMode, alignment: alignment)
    }

    private func showErrorAlert(error: ClassificationError) {
        classificationError = error
        showingErrorAlert = true
        isClassifying = false
    }

    func classifyFlags() {
        guard let selectedImage = selectedImage,
              let cgImage = selectedImage.cgImage
        else {
            showErrorAlert(error: .failureWithReason("The image couldn't be prepared"))
            return
        }

        let model: VNCoreMLModel

        do {
            let classifier = try FlagClassifier(configuration: .init())
            model = try VNCoreMLModel(for: classifier.model)
        } catch {
            showErrorAlert(error: .failureWithError(error))
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results,
                  let classifications = results as? [VNClassificationObservation]
            else {
                self.showErrorAlert(error: .failureWithError(error))
                return
            }

            withAnimation {
                // Remove any results with a confidence level of less than 1%.
                self.classificationResults = classifications.filter { $0.confidence >= 0.01 }
            }

            self.isClassifying = false
        }

        request.imageCropAndScaleOption = imageScaleOption

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        Task {
            try? requestHandler.perform([request])
        }
    }
}
