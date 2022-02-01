//
//  ChartView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/10/2021.
//

import SwiftUI

struct ChartView: View {
    private enum DataType: String, CaseIterable {
        case score = "Score"
        case time = "Time Taken"
    }

    private enum TimeFilter: String, CaseIterable {
        case total = "Relative To Total"
        case rate = "Per Question"
    }

    @Environment(\.dismiss) private var dismiss

    @AppStorage("dataType") private var dataType: DataType = .score

    @State private var savedProgress = SavedProgress.empty

    @State private var filterContinents: Continents = .all
    @State private var filterQuestionRate: TimeFilter = .total

    @State private var showingDeleteConfirmation = false

    private var continentFilters: [Continent?] {
        var allContinents: [Continent?] = [nil]
        allContinents.append(contentsOf: Continent.allCases.sorted())

        return allContinents
    }

    private var dataPoints: [DataPoint] {
        let values = savedProgress.map { progress -> Double in
            switch dataType {
            case .score:
                // Filter progress by selected continents.
                let filteredContinents = progress.progressPerContinent.filter { progress in
                    filterContinents.contains(progress.continent)
                }

                // Combine the individual `score` and `numberOfQuestions` properties into single values.
                let score = filteredContinents.map(\.score).reduce(0, +)
                let numQuestions = filteredContinents.map(\.numberOfQuestions).reduce(0, +)

                return Double(score) / Double(numQuestions)
            case .time:
                guard let timing = progress.timing else { return .nan }

                switch filterQuestionRate {
                case .total:
                    return Double(timing.timeElapsed) / Double(timing.totalTime)
                case .rate:
                    return timing.questionRate / Double(yAxisValues.max() ?? 1) * 10
                }
            }
        }

        // Filters out all values that are NaN.
        return values.filter(\.isFinite).map(DataPoint.init)
    }

    private var continentsFilterButtons: some View {
        FlowLayoutView(continentFilters, spacing: 4) { continent in
            Toggle(continent?.rawValue ?? "All", isOn: toggleBinding(for: continent))
                .toggleStyle(.borderedButton)
                .font(.callout.weight(continent == nil ? .semibold : .regular))
        }
    }

    private var timeFilterButtons: some View {
        FlowLayoutView(TimeFilter.allCases, spacing: 4) { filter in
            Toggle(filter.rawValue, isOn: toggleBinding(for: filter))
                .toggleStyle(.borderedButton)
                .font(.callout)
        }
    }

    private var yAxisValues: StrideThrough<Int> {
        let defaultValues = stride(from: 1, through: 10, by: 1)

        if dataType == .time && filterQuestionRate == .rate {
            let times = savedProgress.compactMap(\.timing?.questionRate)
            guard !times.isEmpty else { return defaultValues }

            let highestValue = Int(times.max()?.rounded(.up) ?? 1)

            return stride(from: highestValue, through: highestValue * 10, by: highestValue)
        } else {
            return defaultValues
        }
    }

    private var yAxisLines: some View {
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

    private var yAxisLabels: some View {
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

    private var noDataText: some View {
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
        .background(in: Capsule())
        .overlay {
            Capsule()
                .stroke(.tint, lineWidth: 2)
        }
    }

    private var lineGraph: some View {
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
        .infiniteMaxWidth()
    }

    private var deleteAllToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Delete All", role: .destructive) {
                showingDeleteConfirmation = true
            }
            .foregroundStyle(.red, disabled: savedProgress.isEmpty)
            .confirmationDialog("Are you sure?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete All Progress", role: .destructive) {
                    dismiss()
                    SavedProgress.empty.save()
                }
            } message: {
                Text("All your progress will be deleted.")
            }
            .disabled(savedProgress.isEmpty)
        }
    }

    private var titleToolbarMenu: some ToolbarContent {
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

    private var doneToolbarButton: some ToolbarContent {
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

    private func toggleBinding(for continent: Continent?) -> Binding<Bool> {
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

    private func toggleBinding(for questionRate: TimeFilter) -> Binding<Bool> {
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
