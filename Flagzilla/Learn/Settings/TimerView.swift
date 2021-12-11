//
//  TimerView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 26/09/2021.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var settings: LearnSettings

    var body: some View {
        Form {
            Toggle("Use timer", isOn: $settings.useTimer.animation())
                .tint(.accentColor)

            if settings.useTimer {
                Picker("Duration", selection: $settings.timerDuration) {
                    ForEach(LearnSettings.timerDurations, id: \.self) { duration in
                        Text("\(duration) min")
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .navigationTitle("Timer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environmentObject(LearnSettings())
    }
}
