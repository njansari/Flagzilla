//
//  ChartView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/10/2021.
//

import SwiftUI

struct DataPoint {
    let value: Double
}

struct ChartView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var filterContinents: Continents = .all
    @State private var filtersHeight: Double = .zero

    var continentFilters: [Continent?] {
        var allContinents: [Continent?] = [nil]
        allContinents.append(contentsOf: Continent.allCases.sorted())

        return allContinents
    }

    var dataPoints: [DataPoint] {
        let savedProgress = SavedProgress.loadSavedProgress()

        let filteredProgress = savedProgress.filter { progress in
            progress.continents == filterContinents
        }

        return filteredProgress.map { progress in
            DataPoint(value: progress.percentageScore)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
//                FlowLayoutView(continentFilters, spacing: 4) { continent in
//                    Toggle(continent?.rawValue ?? "All", isOn: toggleBinding(for: continent))
//                        .toggleStyle(.borderedButton)
//                        .font(.callout.weight(continent == nil ? .semibold : .regular))
//                }
//                .frame(height: filtersHeight)

                ZStack {
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

                    HStack(spacing: 0) {
                        VStack(alignment: .trailing) {
                            ForEach((1...10).reversed(), id: \.self) { i in
                                Text(Double(i) / 10, format: .percent)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.trailing, 5)

                                Spacer()
                            }
                        }

                        Divider()
                            .background(.tint)

                        ZStack {
                            if dataPoints.isEmpty {
                                Text("No Data")
                                    .font(.title.weight(.semibold))
                                    .padding()
                                    .background()
                            } else {
                                LineChartShape(dataPoints: dataPoints, pointSize: 10, drawPoints: false)
                                    .stroke(.tint, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))

                                LineChartShape(dataPoints: dataPoints, pointSize: 10, drawPoints: true)
                                    .fill(.primary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete All", role: .destructive) {
                        SavedProgress.saveProgress([])
                    }
                    .foregroundStyle(.red)
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
