//
//  ClassificiationError.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 11/12/2021.
//

import Foundation

enum ClassificationError: LocalizedError {
    case failureWithMessage(String)
    case failureWithError(Error?)

    var errorDescription: String? {
        switch self {
        case .failureWithMessage(let reason):
            return reason
        case .failureWithError(let error):
            return error?.localizedDescription
        }
    }
}
