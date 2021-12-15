//
//  Collection+SortedKeyPath.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 12/12/2021.
//

import Foundation

extension Collection {
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>, order: SortOrder = .forward) -> [Element] {
        sorted(using: KeyPathComparator(keyPath, order: order))
    }
}
