//
//  NumberKeyboard.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 01/02/2022.
//

import UIKit

class NumberKeyboard: UIView {
    typealias ButtonTappedHandler = (KeyboardElement) -> Void

    let buttonTappedHandler: ButtonTappedHandler

    lazy var gridLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(56))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        return UICollectionViewCompositionalLayout(section: layoutSection)
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        collectionView.backgroundColor = .keyboardBackgroundColor
        collectionView.isScrollEnabled = false
        collectionView.delegate = self

        return collectionView
    }()

    lazy var dataSource: UICollectionViewDiffableDataSource<String, KeyboardElement> = {
        let cellRegistration = UICollectionView.CellRegistration<ButtonCell, KeyboardElement> { cell, indexPath, item in
            cell.keyboardElement = item
        }

        let dataSource = UICollectionViewDiffableDataSource<String, KeyboardElement>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        return dataSource
    }()

    init(buttonTappedHandler: @escaping ButtonTappedHandler) {
        self.buttonTappedHandler = buttonTappedHandler

        let size = CGSize(width: UIScreen.main.bounds.width, height: 300)
        super.init(frame: CGRect(origin: .zero, size: size))

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        applySnapshot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applySnapshot() {
        let sectionName = "main"

        var snapshot = NSDiffableDataSourceSnapshot<String, KeyboardElement>()
        snapshot.appendSections([sectionName])

        let numbers: [KeyboardElement] = (1...9).map { .number($0) }

        var items: [KeyboardElement] = [.enter, .number(0), .delete]
        items.insert(contentsOf: numbers, at: 0)

        snapshot.appendItems(items, toSection: sectionName)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension NumberKeyboard: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            buttonTappedHandler(item)
            UIDevice.current.playInputClick()
        }

        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
