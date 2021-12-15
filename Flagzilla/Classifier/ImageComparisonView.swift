//
//  ImageComparisonView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import SwiftUI

struct ImageComparisonView: View {
    @ObservedObject private(set) var classifier: FlagImageClassifier

    @State private var selectedImageHeight: CGFloat?
    @Binding var comparisonCountry: Country?

    private var closeButton: some View {
        CloseButton {
            withAnimation {
                comparisonCountry = nil
            }
        }
        .frame(width: 32, height: 32)
        .padding()
    }

    var body: some View {
        if let country = comparisonCountry, let selectedImage = classifier.selectedImage {
            ZStack(alignment: .topTrailing) {
                VStack {
                    Spacer()

                    selectedImageView(for: selectedImage)

                    Spacer()

                    suggestedFlagView(for: country)

                    Spacer()
                }
                .font(.caption.bold())
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                closeButton
            }
            .background(.thinMaterial)
        }
    }

    private func image(for country: Country) -> some View {
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

    private func selectedImageView(for image: UIImage) -> some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(options: classifier.imageOptions)
                .onSizeChange { selectedImageHeight = $0.height }
                .frame(width: 299, height: selectedImageHeight?.clamped(to: 0...299))
                .clipped()

            Text("Selected Image")
        }
    }

    private func suggestedFlagView(for country: Country) -> some View {
        VStack {
            image(for: country)
                .frame(width: 299)

            Text("Suggested Flag")
        }
    }
}

struct ImageComparisonView_Previews: PreviewProvider {
    static let classifier: FlagImageClassifier = {
        let classifier = FlagImageClassifier()
        classifier.selectedImage = UIImage(systemName: "photo.fill")
        classifier.imageScaleOption = .scaleFit

        return classifier
    }()

    static var previews: some View {
        ImageComparisonView(classifier: classifier, comparisonCountry: .constant(.example))
    }
}
