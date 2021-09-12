//
//  FlagzillaApp.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 27/08/2021.
//

import SwiftUI

@main struct FlagzillaApp: App {
    @StateObject private var settings = Settings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
