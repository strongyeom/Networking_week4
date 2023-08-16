//
//  KoGPT.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/16.
//

import Foundation

// MARK: - KoGPT
struct KoGPT: Codable {
    let id: String
    let generations: [Generation]
    let usage: Usage
}

// MARK: - Generation
struct Generation: Codable {
    let text: String
    let tokens: Int
}

// MARK: - Usage
struct Usage: Codable {
    let promptTokens, generatedTokens, totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case generatedTokens = "generated_tokens"
        case totalTokens = "total_tokens"
    }
}
