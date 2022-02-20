//
//  FlagImageClassifier.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import SwiftUI
import Vision

@MainActor final class FlagImageClassifier: ObservableObject {
    typealias StopClassificationHandler = (ClassificationError?) -> Void

    struct ImageConfigurationOptions {
        let aspectRatio: CGFloat?
        let contentMode: ContentMode
        let alignment: Alignment
    }

    @Published var selectedImage: UIImage?
    @Published var imageScaleOption: VNImageCropAndScaleOption = .centerCrop

    @Published var classificationResults: [VNClassificationObservation]?

    var stopClassificationHandler: StopClassificationHandler?

    var imageOptions: ImageConfigurationOptions {
        let aspectRatio: CGFloat? = imageScaleOption == .scaleFill ? 1 : nil
        let contentMode: ContentMode = imageScaleOption == .scaleFit ? .fit : .fill
        let alignment: Alignment = imageScaleOption == .scaleFit ? .topLeading : .center

        return ImageConfigurationOptions(aspectRatio: aspectRatio, contentMode: contentMode, alignment: alignment)
    }

    func startClassification() {
        // Convert the image to the format used by the model.
        guard let selectedImage = selectedImage,
              let cgImage = selectedImage.cgImage
        else {
            stopClassificationHandler?(.failureWithMessage("The image couldn't be prepared"))
            return
        }

        // Create a container for the model used to make the request.
        let model: VNCoreMLModel

        do {
            let classifier = try FlagClassifier(configuration: .init())
            model = try VNCoreMLModel(for: classifier.model)
        } catch {
            stopClassificationHandler?(.failureWithError(error))
            return
        }

        // Create a request with the user's image configuration options.
        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = imageScaleOption

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Execute the request.
        do {
            try requestHandler.perform([request])
        } catch {
            stopClassificationHandler?(.failureWithError(error))
            return
        }

        // Read the results from the request.
        let results = request.results as? [VNClassificationObservation]

        // Remove any results with a confidence level of less than 1%.
        let filteredResults = results?.filter { $0.confidence >= 0.01 }

        withAnimation {
            classificationResults = filteredResults?.sorted(by: \.confidence, order: .reverse)
        }

        stopClassificationHandler?(nil)
    }
}
