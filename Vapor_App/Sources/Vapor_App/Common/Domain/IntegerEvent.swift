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
    
    init(id: UUID = UUID(), timestamp: Date = .now, value: Int) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
    }
    
    func jsonData() throws -> Data {
        return try encoder.encode(self)
    }
    
    func jsonString() throws -> String {
        return String(data: try jsonData(), encoding: .utf8)!
    }
}
