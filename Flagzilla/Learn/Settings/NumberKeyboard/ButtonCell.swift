//
//  ButtonCell.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/02/2022.
//

import UIKit

extension NumberKeyboard {
    class ButtonCell: UICollectionViewCell {
        var keyboardElement: KeyboardElement?

        override func updateConfiguration(using state: UICellConfigurationState) {
            guard let keyboardElement = keyboardElement else { return }

            var newBackgroundConfiguration = UIBackgroundConfiguration.listGroupedCell().updated(for: state)

            switch keyboardElement {
            case .number:
                if state.isHighlighted {
                    newBackgroundConfiguration.backgroundColor = .highlightedKeyboardButtonColor
                } else {
                    newBackgroundConfiguration.backgroundColor = .keyboardButtonColor
                }
            case .enter:
                if state.isHighlighted {
                    newBackgroundConfiguration.backgroundColor = .tintColor
                } else {
                    fallthrough
                }
            case .delete:
                newBackgroundConfiguration.backgroundColor = .clear
            }

            newBackgroundConfiguration.cornerRadius = 5

            backgroundConfiguration = newBackgroundConfiguration

            var newContentConfiguration = ButtonCellContentConfiguration().updated(for: state)
            newContentConfiguration.keyboardElement = keyboardElement

            contentConfiguration = newContentConfiguration
        }
    }
}
