//
//  InformationRowView.swift
//  InformationRowView
//
//  Created by Nayan Jansari on 12/09/2021.
//

import SwiftUI

// A basic layout template view that is used to show information about a country.
struct InformationRowView: View {
    let label: LocalizedStringKey
    let content: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)

            Text(content)
        }
    }
}

struct InformationRowView_Previews: PreviewProvider {
    static var previews: some View {
        InformationRowView(label: "Label", content: "Content")
    }
}
