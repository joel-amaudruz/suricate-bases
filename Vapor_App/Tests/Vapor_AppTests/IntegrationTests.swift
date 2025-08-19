//
//  IntegrationTests.swift
//  Vapor_App
//
//  Created by Tarquinio Teles on 19/08/25.
//

@testable import Vapor_App
import VaporTesting
import Testing

@Suite("Integration Tests")
struct IntegrationTests {
    @Test("Test Nats Messaging")
    func natsMessagingBasicTest() async throws {
        let messenger = try? NatsMessagingService()
        
        #expect(messenger != nil)
    }
}
