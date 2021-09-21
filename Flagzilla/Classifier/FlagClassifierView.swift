//
//  FlagClassifierView.swift
//  FlagClassifierView
//
//  Created by Nayan Jansari on 11/09/2021.
//

import SwiftUI

struct FlagClassifierView: View {
    var body: some View {
        NavigationView {
            Form {
                Button("Select Image") {

                }
                .buttonStyle(.listRow)
            }
            .navigationTitle("Flag Classifier")
        }
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        FlagClassifierView()
    }
}
