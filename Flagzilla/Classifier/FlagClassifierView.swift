//
//  FlagClassifierView.swift
//  FlagClassifierView
//
//  Created by Nayan Jansari on 11/09/2021.
//

import SwiftUI
import Vision

struct FlagClassifierView: View {
    @StateObject private var classifier = FlagImageClassifier()

    @State private var comparisonCountry: Country?

    @State private var resultsExpanded = false

    private var startButton: some View {
        Button {
            classifier.isClassifying = true
            classifier.classifyFlags()
        } label: {
            if classifier.isClassifying {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Start Classification")
            }
        }
        .buttonStyle(.listRow)
        .disabled(classifier.selectedImage == nil)
        .allowsHitTesting(!classifier.isClassifying)
        .alert(isPresented: $classifier.showingErrorAlert, error: classifier.classificationError) {
            Button("OK") {
                classifier.classificationError = nil
            }
        }
    }

    private var displayedResults: [VNClassificationObservation] {
        guard let classificationResults = classifier.classificationResults else { return [] }
        return Array(classificationResults.prefix(resultsExpanded ? 5 : 1))
    }

    var displayedResultsList: some View {
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
            .font(result == classifier.classificationResults?.first ? .body.bold() : .body)
        }
    }

    private var resultsSection: some View {
        Section {
            if displayedResults.isEmpty {
                Text("There were no flags detected")
                    .fontWeight(.medium)
            } else {
                displayedResultsList
            }
        } header: {
            Text("Best Matches")
        } footer: {
            if classifier.classificationResults?.count ?? 0 > 1 && !resultsExpanded {
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
                ClassificationImagePreview(classifier: classifier, resultsExpanded: $resultsExpanded)

                if classifier.classificationResults == nil {
                    startButton
                } else {
                    resultsSection
                }
            }
            .navigationTitle("Flag Classifier")
        }
        .overlay {
            ImageComparisonView(classifier: classifier, comparisonCountry: $comparisonCountry)
        }
    }
}

struct FlagClassifierView_Previews: PreviewProvider {
    static var previews: some View {
        FlagClassifierView()
    }
}
