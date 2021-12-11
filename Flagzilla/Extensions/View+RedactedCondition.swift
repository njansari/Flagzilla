//
//  View+RedactedCondition.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 02/12/2021.
//

import SwiftUI

extension View {
    @ViewBuilder func redacted(when condition: Bool) -> some View {
        if condition {
            redacted(reason: .placeholder)
        } else {
            unredacted()
        }
    }
}
