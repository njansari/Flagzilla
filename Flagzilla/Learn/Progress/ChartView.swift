//
//  ChartView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/10/2021.
//

import SwiftUI

struct DataPoint: Equatable {
    let value: Double
}

struct ChartView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var filterContinents: Continents = .all
    @State private var showingDeleteConfirmation = false

    @ScaledMetric private var spacing = 16

    let savedProgress: [SavedProgress] = {
        var progress: [SavedProgress] = []
        progress.loadSaved()

        return progress
    }()

    var continentFilters: [Continent?] {
        var allContinents: [Continent?] = [nil]
        allContinents.append(contentsOf: Continent.allCases.sorted())

        return allContinents
    }

    var dataPoints: [DataPoint] {
        let values = savedProgress.map { progress -> Double in
            let filteredContinents = progress.progressPerContinent.filter { progress in
                filterContinents.contains(progress.continent)
            }

            let score = filteredContinents.map(\.score).reduce(0, +)
            let numQuestions = filteredContinents.map(\.numberOfQuestions).reduce(0, +)

            return Double(score) / Double(numQuestions)
        }

        return values.filter(\.isFinite).map(DataPoint.init)
    }

    var continentsFilterButtons: some View {
        FlowLayoutView(continentFilters, spacing: 4) { continent in
            Toggle(continent?.rawValue ?? "All", isOn: toggleBinding(for: continent))
                .toggleStyle(.borderedButton)
                .font(.callout.weight(continent == nil ? .semibold : .regular))
        }
    }

    var horizontalAxisLines: some View {
        VStack {
            ForEach(1...10, id: \.self) { _ in
                Divider()

                Spacer()
            }
        }
        .overlay(alignment: .bottom) {
            Divider()
                .background(.tint)
        }
    }

    var axisLabels: some View {
        VStack(alignment: .trailing) {
            ForEach((1...10).reversed(), id: \.self) { step in
                Text(Double(step) / 10, format: .percent)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 5)

                Spacer()
            }
        }
    }

    var lineGraph: some View {
        ZStack {
            if dataPoints.isEmpty {
                VStack {
                    Text("No Data")
                        .font(.title.weight(.semibold))

                    Text("Start learning your flags to see your progress here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: 200)
                .padding()
                .background {
                    Capsule()
                        .stroke(.tint, lineWidth: 2)
                        .background()
                }
            } else {
                LineChartShape(for: .line, dataPoints: dataPoints, pointSize: 10)
                    .stroke(.tint, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))

                LineChartShape(for: .points, dataPoints: dataPoints, pointSize: 10)
                    .fill(.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: spacing) {
                continentsFilterButtons

                ZStack {
                    horizontalAxisLines

                    HStack(spacing: 0) {
                        axisLabels

                        Divider()
                            .background(.tint)

                        lineGraph
                    }
                }
            }
            .padding()
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete All", role: .destructive) {
                        showingDeleteConfirmation = true
                    }
                    .foregroundStyle(.red)
                    .confirmationDialog("Are you sure?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                        Button("Delete All Progress", role: .destructive) {
                            ([] as [SavedProgress]).save()
                        }
                    } message: {
                        Text("All your progress will be deleted.")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
    }

    func toggleBinding(for continent: Continent?) -> Binding<Bool> {
        Binding {
            if let continent = continent {
                return filterContinents == [continent]
            } else {
                return filterContinents == .all
            }
        } set: { _ in
            if let continent = continent {
                filterContinents = [continent]
            } else {
                filterContinents = .all
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
