//
//  Bundle+DecodeJSON.swift
//  Bundle+DecodeJSON
//
//  Created by Nayan Jansari on 28/08/2021.
//

import Foundation

extension Bundle {
    func decodeJSON<T: Decodable>(ofType type: T.Type = T.self, from file: String) -> T {
        let fileName = NSString(string: file).deletingPathExtension

        guard let url = url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to locate \(fileName).json in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(fileName).json from bundle.")
        }

        let decoder = JSONDecoder()

        do {
            return try decoder.decode(type, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(fileName).json from bundle due to missing key '\(key.stringValue)' not found: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(fileName).json from bundle due to type mismatch: \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(fileName).json from bundle due to missing \(type) value: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(fileName).json from bundle because it appears to be invalid JSON: \(context.debugDescription)")
        } catch {
            fatalError("Failed to decode \(fileName).json from bundle: \(error.localizedDescription)")
        }
    }
}
