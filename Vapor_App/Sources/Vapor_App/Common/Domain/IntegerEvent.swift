//
//  Event.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 20/08/25.
//

import Foundation

struct IntegerEvent: Codable {
    let id: UUID
    let timestamp: Date
    let value: Int
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    init(id: UUID = UUID(), timestamp: Date = .now, value: Int) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
    }
    
    func jsonData() throws -> Data {
        return try Self.encoder.encode(self)
    }
    
    func jsonString() throws -> String {
        return String(data: try jsonData(), encoding: .utf8)!
    }
}
