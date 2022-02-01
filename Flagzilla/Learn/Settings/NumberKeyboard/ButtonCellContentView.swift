//
//  ButtonCellContentView.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/02/2022.
//

import UIKit

extension NumberKeyboard {
    class ButtonCellContentView: UIView, UIContentView {
        private var currentConfiguration: ButtonCellContentConfiguration!

        var configuration: UIContentConfiguration {
            get { currentConfiguration }
            set {
                guard let newConfiguration = newValue as? ButtonCellContentConfiguration else { return }
                applyConfiguration(newConfiguration)
            }
        }

        let textLabel = UILabel()
        let imageView = UIImageView()

        init(configuration: ButtonCellContentConfiguration) {
            super.init(frame: .zero)

            setupViews()
            applyConfiguration(configuration)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setupViews() {
            imageView.contentMode = .scaleAspectFit
            imageView.preferredSymbolConfiguration = .init(textStyle: .title3)
            imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
            imageView.translatesAutoresizingMaskIntoConstraints = false

            textLabel.adjustsFontForContentSizeCategory = true
            textLabel.translatesAutoresizingMaskIntoConstraints = false

            addSubview(imageView)
            addSubview(textLabel)

            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
                textLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
                textLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
            ])
        }

        func applyConfiguration(_ config: ButtonCellContentConfiguration) {
            guard currentConfiguration != config else { return }
            currentConfiguration = config

            guard let keyboardElement = config.keyboardElement else { return }
            let symbolImageIsFilled = config.symbolImageIsFilled ?? false

            switch keyboardElement {
            case .enter:
                textLabel.text = "done"
                textLabel.textColor = config.textColor
                textLabel.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: .systemFont(ofSize: 20, weight: .medium))
            case .number(let number):
                textLabel.text = number.formatted()
                textLabel.font = .preferredFont(forTextStyle: .title3)
            case .delete:
                imageView.image = UIImage(systemName: symbolImageIsFilled ? "delete.left.fill" : "delete.left")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            }
        }
    }
}
