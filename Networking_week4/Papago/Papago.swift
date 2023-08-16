//
//  Papago.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/16.
//

import Foundation

// MARK: - Papago
struct Papago: Codable {
    let message: Message
}

// MARK: - Message
struct Message: Codable {
    let result: Result
    let type, service, version: String

    enum CodingKeys: String, CodingKey {
        case result
        case type = "@type"
        case service = "@service"
        case version = "@version"
    }
}

// MARK: - Result
struct Result: Codable {
    let srcLangType, tarLangType, translatedText, engineType: String
}
