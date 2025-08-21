//
//  SuricateCry.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 20/08/25.
//

import Foundation

enum SuricateCryActions: String, Codable {
    case emailNotification
    case smsNotification
    case urlNotification
    case httpRequest
    case externalScript
    case natsPushback
    case none
    case unknown
}

struct SuricateCry: Codable {
    let id: UUID
    let timestamp: Date
    let action: SuricateCryActions
    let message: String?
    let destination: String?
    
    static let CryChannel = "suricate.cry"
    
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
    
    init(id: UUID = UUID(),
         timestamp: Date = .now,
         action: SuricateCryActions,
         message: String?,
         destination: String?
    ) {
        self.id = id
        self.timestamp = timestamp
        self.action = action
        self.message = message
        self.destination = destination
    }
    
    init(with str: String) throws {
        let data = str.data(using: .utf8)!
        self = try Self.decoder.decode(SuricateCry.self, from: data)
    }
    
    func jsonData() throws -> Data {
        return try Self.encoder.encode(self)
    }
    
    func jsonString() throws -> String {
        return String(data: try jsonData(), encoding: .utf8)!
    }

}
