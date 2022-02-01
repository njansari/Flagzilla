//
//  ButtonCellContentConfiguration.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/02/2022.
//

import UIKit

extension NumberKeyboard {
    struct ButtonCellContentConfiguration: Equatable, UIContentConfiguration {
        var keyboardElement: KeyboardElement?
        var textColor: UIColor?
        var symbolImageIsFilled: Bool?

        func makeContentView() -> UIView & UIContentView {
            ButtonCellContentView(configuration: self)
        }

        func updated(for state: UIConfigurationState) -> ButtonCellContentConfiguration {
            guard let state = state as? UICellConfigurationState,
                  let keyboardElement = keyboardElement
            else { return self }

            var updatedConfiguration = self

            switch keyboardElement {
            case .delete:
                updatedConfiguration.symbolImageIsFilled = state.isHighlighted
            case .enter:
                if state.isHighlighted {
                    updatedConfiguration.textColor = .white
                } else {
                    updatedConfiguration.textColor = .tintColor
                }
            default:
                break
            }

            return updatedConfiguration
        }
    }
}
