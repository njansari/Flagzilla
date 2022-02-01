//
//  UIColor+Keyboard.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/02/2022.
//

import UIKit

extension UIColor {
    class var keyboardButtonColor: UIColor {
        UIColor(named: "KeyboardButtonColor") ?? .systemBackground
    }

    class var highlightedKeyboardButtonColor: UIColor {
        UIColor(named: "HighlightedKeyboardButtonColor") ?? .systemBackground
    }

    class var keyboardBackgroundColor: UIColor {
        UIColor(named: "KeyboardBackgroundColor") ?? .systemBackground
    }
}
