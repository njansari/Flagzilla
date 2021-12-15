//
//  FlagImageClassifier.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import SwiftUI
import Vision

@MainActor class FlagImageClassifier: ObservableObject {
    typealias StopClassificationHandler = (ClassificationError?) -> Void

    struct ImageScaleOptions {
        let aspectRatio: CGFloat?
        let contentMode: ContentMode
        let alignment: Alignment
    }

    @Published var selectedImage: UIImage?
    @Published var imageScaleOption: VNImageCropAndScaleOption = .centerCrop

    @Published var classificationResults: [VNClassificationObservation]?

    var stopClassificationHandler: StopClassificationHandler?

    var imageOptions: ImageScaleOptions {
        let aspectRatio: CGFloat? = imageScaleOption == .scaleFill ? 1 : nil
        let contentMode: ContentMode = imageScaleOption == .scaleFit ? .fit : .fill
        let alignment: Alignment = imageScaleOption == .scaleFit ? .topLeading : .center

        return ImageScaleOptions(aspectRatio: aspectRatio, contentMode: contentMode, alignment: alignment)
    }

    func classifyFlags() {
        guard let selectedImage = selectedImage,
              let cgImage = selectedImage.cgImage
        else {
            stopClassificationHandler?(.failureWithMessage("The image couldn't be prepared"))
            return
        }

        let model: VNCoreMLModel

        do {
            let classifier = try FlagClassifier(configuration: .init())
            model = try VNCoreMLModel(for: classifier.model)
        } catch {
            stopClassificationHandler?(.failureWithError(error))
            return
        }

        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = imageScaleOption

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        do {
            try requestHandler.perform([request])
        } catch {
            stopClassificationHandler?(.failureWithError(error))
        }

        let results = request.results as? [VNClassificationObservation]

        // Remove any results with a confidence level of less than 1%.
        let filteredResults = results?.filter { $0.confidence >= 0.01 }

        withAnimation {
            classificationResults = filteredResults?.sorted(by: \.confidence, order: .reverse)
        }

        stopClassificationHandler?(nil)
    }
}
