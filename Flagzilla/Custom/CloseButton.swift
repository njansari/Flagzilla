//
//  CloseButton.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 30/11/2021.
//

import SwiftUI

struct CloseButton: UIViewRepresentable {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    func makeUIView(context: Context) -> some UIView {
        let buttonAction = UIAction { _ in action() }
        return UIButton(type: .close, primaryAction: buttonAction)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton {}
    }
}
