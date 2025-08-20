//
//  SuricateCry.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 20/08/25.
//

import Foundation

enum SuricateCryActions: String, Codable {
    case email
    case sms
    case push
    case none
}

struct SuricateCry: Codable {
    let id: UUID
    let timestamp: Date
    let action: SuricateCryActions
    let message: String?
    
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    init(id: UUID = UUID(), timestamp: Date = .now, action: SuricateCryActions, message: String?) {
        self.id = id
        self.timestamp = timestamp
        self.action = action
        self.message = message
    }
    
    func jsonData() throws -> Data {
        return try encoder.encode(self)
    }
    
    func jsonString() throws -> String {
        return String(data: try jsonData(), encoding: .utf8)!
    }

}
