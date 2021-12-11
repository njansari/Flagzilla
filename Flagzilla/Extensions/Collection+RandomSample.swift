//
//  Collection+RandomSample.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 03/12/2021.
//

import Foundation

// https://github.com/apple/swift-algorithms/blob/main/Sources/Algorithms/RandomSample.swift

extension Collection {
    /// Randomly selects the specified number of elements from this collection,
    /// maintaining their relative order.
    ///
    /// - Parameters:
    ///   - k: The number of elements to randomly select.
    /// - Returns: An array of `k` random elements. If `k` is greater than this
    ///   collection's count, then this method returns the full collection.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    func randomSample(count k: Int) -> [Element] {
        guard k > 0 else { return [] }
        guard k < count else { return Array(self) }

        var result: [Element] = []
        result.reserveCapacity(k)

        var remainingCount = count
        var countToSelect = k
        var i = startIndex

        while countToSelect > 0 {
            let r = Int.random(in: 0..<remainingCount)

            if r < countToSelect {
                result.append(self[i])
                countToSelect -= 1
            }

            formIndex(after: &i)
            remainingCount -= 1
        }

        return result
    }
}
