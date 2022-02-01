//
//  NumberTextField.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 25/12/2021.
//

import SwiftUI

struct NumberTextField: UIViewRepresentable {
    @Binding var value: Int

    let validateText: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.textAlignment = .right
        textField.textColor = .tintColor
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true

        let inputView = NumberKeyboard { element in
            switch element {
            case .number(let number):
                textField.text?.append(number.formatted())
            case .delete:
                _ = textField.text?.popLast()
            case .enter:
                textField.resignFirstResponder()

                if let text = textField.text, let value = try? Int(text, format: .number) {
                    self.value = value
                } else {
                    textField.text = value.formatted()
                }

                validateText()
            }
        }

        textField.inputView = inputView

        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = value.formatted()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(numberTextField: self)
    }
}

extension NumberTextField {
    class Coordinator: NSObject, UITextFieldDelegate {
        private let numberTextField: NumberTextField

        init(numberTextField: NumberTextField) {
            self.numberTextField = numberTextField
        }

        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            let position = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: position, to: position)

            return true
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.textColor = .label
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            textField.textColor = .tintColor
        }
    }
}

