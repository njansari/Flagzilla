//
//  ClassificiationError.swift
//  Flagzilla
//
//  Created by Nayan Jansari on 11/12/2021.
//

import Foundation

// The possible types of errors thrown when attempting
// to classify a flag from a user's image. The error can
// be provided a message or an optional system error object.
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
