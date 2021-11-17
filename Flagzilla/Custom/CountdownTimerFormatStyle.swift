//
//  CountdownTimerFormatStyle.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 14/11/2021.
//

import Foundation

struct CountdownTimerFormatStyle: FormatStyle {
    func format(_ value: Int) -> String {
        let minutes = value / 60 % 60
        let seconds = value % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

extension FormatStyle where Self == CountdownTimerFormatStyle {
    static var countdownTimer: CountdownTimerFormatStyle {
        CountdownTimerFormatStyle()
    }
}
