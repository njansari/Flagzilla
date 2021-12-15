//
//  AsyncFlagImage.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/12/2021.
//

import SwiftUI

struct AsyncFlagImage<ImageContent: View, Placeholder: View, ErrorContent: View>: View {
    let url: URL?
    let animation: Animation?

    let imageContent: (Image) -> ImageContent
    let placeholder: () -> Placeholder
    let errorContent: (Error) -> ErrorContent

    init(url: URL?, animation: Animation? = nil,
         @ViewBuilder content: @escaping (Image) -> ImageContent,
         @ViewBuilder placeholder: @escaping () -> Placeholder,
         @ViewBuilder error: @escaping (Error) -> ErrorContent
    ) {
        self.url = url
        self.animation = animation
        self.imageContent = content
        self.placeholder = placeholder
        self.errorContent = error
    }

    init(url: URL?, animation: Animation? = nil,
         @ViewBuilder content: @escaping (Image) -> ImageContent,
         @ViewBuilder placeholder: @escaping () -> Placeholder
    ) where ErrorContent == EmptyView {
        self.init(url: url, animation: animation, content: content, placeholder: placeholder) { _ in EmptyView() }
    }

    var body: some View {
        AsyncImage(url: url, scale: 3, transaction: .init(animation: animation)) { phase in
            switch phase {
            case .success(let image):
                imageContent(image)
            case .failure(let error):
                errorContent(error)
            default:
                placeholder()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncFlagImage(url: Country.example.mediumFlag) { $0 } placeholder: { ProgressView() }
    }
}
