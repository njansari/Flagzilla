//
//  ConverterView.swift
//  ConverterView
//
//  Created by Nayan Jansari on 11/09/2021.
//

import SwiftUI

enum ConversionStyle: String, CaseIterable {
    case textToFlag = "Text to Flag"
    case flagToText = "Flag to Text"
}

struct ConverterView: View {
    @State private var conversionStyle: ConversionStyle = .textToFlag

    var body: some View {
        NavigationView {
            Form {
                Picker("Conversion Style", selection: $conversionStyle) {
                    ForEach(ConversionStyle.allCases, id: \.self) { style in
                        Text(style.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Converter")
        }
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
    }
}
