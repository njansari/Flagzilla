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

extension View {
    @ViewBuilder func foregroundStyle<S: ShapeStyle>(_ style: S, disabled: Bool) -> some View {
        if disabled {
            foregroundStyle(.tertiary)
        } else {
            foregroundStyle(style)
        }
    }
}

struct ChartView: View {
    enum DataType: String, CaseIterable {
        case score = "Score"
        case time = "Time Taken"
    }

    enum TimeFilter: String, CaseIterable {
        case total = "Relative To Total"
        case rate = "Per Question"
    }

    @Environment(\.dismiss) private var dismiss

    @AppStorage("dataType") private var dataType: DataType = .score

    @State private var savedProgress = SavedProgress.empty

    @State private var filterContinents: Continents = .all
    @State private var filterQuestionRate: TimeFilter = .total

    @State private var showingDeleteConfirmation = false

    var continentFilters: [Continent?] {
        var allContinents: [Continent?] = [nil]
        allContinents.append(contentsOf: Continent.allCases.sorted())

        return allContinents
    }

    var dataPoints: [DataPoint] {
        let values = savedProgress.map { progress -> Double in
            switch dataType {
                case .score:
                    let filteredContinents = progress.progressPerContinent.filter { progress in
                        filterContinents.contains(progress.continent)
                    }

                    let score = filteredContinents.map(\.score).reduce(0, +)
                    let numQuestions = filteredContinents.map(\.numberOfQuestions).reduce(0, +)

                    return Double(score) / Double(numQuestions)
                case .time:
                    guard let timing = progress.timing else { return .nan }

                    switch filterQuestionRate {
                        case .total:
                            return Double(timing.timeElapased) / Double(timing.totalTime)
                        case .rate:
                            return timing.questionRate / Double(yAxisValues.max() ?? 1) * 10
                    }
            }
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

    var timeFilterButtons: some View {
        FlowLayoutView(TimeFilter.allCases, spacing: 4) { filter in
            Toggle(filter.rawValue, isOn: toggleBinding(for: filter))
                .toggleStyle(.borderedButton)
                .font(.callout)
        }
    }

    var yAxisValues: StrideThrough<Int> {
        if dataType == .time && filterQuestionRate == .rate {
            let times = savedProgress.compactMap(\.timing?.questionRate)

            guard !times.isEmpty else { return stride(from: 1, through: 10, by: 1) }

            let highestValue = (times.max() ?? 1).rounded(.up)
            return stride(from: Int(highestValue), through: Int(highestValue * 10), by: Int.Stride(highestValue))
        } else {
            return stride(from: 1, through: 10, by: 1)
        }
    }

    var yAxisLines: some View {
        VStack {
            ForEach(Array(yAxisValues), id: \.self) { _ in
                Divider()
                Spacer()
            }
        }
        .overlay(alignment: .bottom) {
            Divider()
                .background(.tint)
        }
    }

    var yAxisLabels: some View {
        VStack(alignment: .trailing) {
            ForEach(yAxisValues.reversed(), id: \.self) { value in
                Group {
                    if dataType == .time && filterQuestionRate == .rate {
                        Text("\((Double(value) / 10).formatted(.number.precision(.fractionLength(1)))) sec")
                    } else {
                        Text(Double(value) / 10, format: .percent)
                    }
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.trailing, 5)

                Spacer()
            }
        }
    }

    var noDataText: some View {
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
    }

    var lineGraph: some View {
        ZStack {
            if dataPoints.isEmpty {
                noDataText
            } else {
                LineChartShape(for: .line, dataPoints: dataPoints, pointSize: 10)
                    .stroke(.tint, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))

                LineChartShape(for: .points, dataPoints: dataPoints, pointSize: 10)
                    .fill(Color(white: 0.6))
            }
        }
        .frame(maxWidth: .infinity)
    }

    var deleteAllToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Delete All", role: .destructive) {
                showingDeleteConfirmation = true
            }
            .foregroundStyle(.red, disabled: savedProgress.isEmpty)
            .confirmationDialog("Are you sure?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete All Progress", role: .destructive, action: SavedProgress.empty.save)
            } message: {
                Text("All your progress will be deleted.")
            }
            .disabled(savedProgress.isEmpty)
        }
    }

    var titleToolbarMenu: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Menu {
                Picker("Data type", selection: $dataType) {
                    ForEach(DataType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("Progress")
                        .foregroundColor(.primary)

                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                }
            }
            .font(.headline)
        }
    }

    var doneToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Done", action: dismiss.callAsFunction)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                switch dataType {
                    case .score:
                        continentsFilterButtons
                    case .time:
                        timeFilterButtons
                }

                ZStack {
                    yAxisLines

                    HStack(spacing: 0) {
                        yAxisLabels

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
                deleteAllToolbarButton
                titleToolbarMenu
                doneToolbarButton
            }
            .task {
                await savedProgress.loadSaved()
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

    func toggleBinding(for questionRate: TimeFilter) -> Binding<Bool> {
        Binding {
            filterQuestionRate == questionRate
        } set: { _ in
            filterQuestionRate = questionRate
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
